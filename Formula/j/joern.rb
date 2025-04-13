class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.320.tar.gz"
  sha256 "0ce966a9b56b272233a96c7517a9d5e528281f132d25c17cd83fb0f053442047"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f35d8a8642aba0edcf405b7f50f5c6dacb364a08b127bc2aa264e2e5278b124"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "862fea168ee6504a041cd7bdf2dbe1235bed740c4371de8cf27b02bc85ffa8a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "862fea168ee6504a041cd7bdf2dbe1235bed740c4371de8cf27b02bc85ffa8a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e5e2cd68edae36fffa47da09c725799a8a4f6570d8e87f2169beb8877f255c8"
    sha256 cellar: :any_skip_relocation, ventura:       "56268a704e5e9295cbb8f0fe818b928221f15013495be23e1306b40ea412a73d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "408da43e671f009c27350ad89d6f4d9ff1dc72bcf3cf9cdc8b4e2f796cd601de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ac7cfd3f2828659130811be2dfe82982d3f19e0f02004ef24562ac5472a847e"
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
    assert_path_exists testpath/"cpg.bin"
  end
end
