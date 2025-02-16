class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.250.tar.gz"
  sha256 "aab4654d317cdae12b283f040d58cbcdd3da9eb75161d28caaa5230651e1bae3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08d70a13a25ec06493ccb935beeaba10bcb6917fc6e4a5f237147fdeb5b7297d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e987b4612256421752f5b2ca5ffe8f4b12729bf19bd46dffd35df9908eb0b3a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28dbccd83d1ece1ed6211021b352049f0883c909fd242106987b0bc8d09e0bde"
    sha256 cellar: :any_skip_relocation, sonoma:        "21573ce0a440b591c9f354c995dcd4130586d40cc71505a84480fcbd2926cf56"
    sha256 cellar: :any_skip_relocation, ventura:       "02a20c4c7374d974e66347a3cf6b6eacf1a85f0b60e0978726209d3da0ae9b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd6925343a7c678cc90dcc86f3153b94bb75fe2bde17dc87d7d909174c28d411"
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
