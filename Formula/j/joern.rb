class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.240.tar.gz"
  sha256 "27c33250fac5a9f98e239bd4b4265be9b2e97c8db2c47d0b65b128a7eb7ef578"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40b11eed5a5167cf3878eb26ad4f58fc4b18ebd1bd62d608e5b6c9544bc4da01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17b097b1c036a32e09c5c41c8b0c24ab05fc5ef87d5b91ec6c3075605de7f7a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40b11eed5a5167cf3878eb26ad4f58fc4b18ebd1bd62d608e5b6c9544bc4da01"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8fc95aabf0927064339336fad1313e1fb3b95d8fade4179850fabecc4a97395"
    sha256 cellar: :any_skip_relocation, ventura:       "c8fc95aabf0927064339336fad1313e1fb3b95d8fade4179850fabecc4a97395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdbcc01beefd372ca47860447ed3d656588a47e97b5475094ca55b8c9cd9b30f"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  uses_from_macos "zlib"

  def install
    system "sbt", "stage"

    cd "joern-cli/target/universal/stage" do
      rm(Dir["**/*.bat"])
      libexec.install Pathname.pwd.children
    end

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    astgen_suffix = Hardware::CPU.intel? ? [os] : ["#{os}-#{Hardware::CPU.arch}", "#{os}-arm"]
    libexec.glob("frontends/{csharp,go,js}src2cpg/bin/astgen/{dotnet,go,}astgen-*").each do |f|
      f.unlink unless f.basename.to_s.end_with?(*astgen_suffix)
    end

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (bin/f.basename).write_env_script f, Language::Java.overridable_java_home_env
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      void print_number(int x) {
        std::cout << x << std::endl;
      }

      int main(void) {
        print_number(42);
        return 0;
      }
    CPP

    assert_match "Parsing code", shell_output("#{bin}/joern-parse test.cpp")
    assert_predicate testpath/"cpg.bin", :exist?
  end
end
