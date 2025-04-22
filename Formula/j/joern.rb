class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.330.tar.gz"
  sha256 "bc6398f860c17cfffbf894894d151700d9d00a047fa7b272275e1f647768cf9b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c901df804b26d97dee288a5b09cd6a64dda0bea1e937d5b72f8c6e214c3b94dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e092ed84cd6114389b1ea6bc1a6bbf280ef895554adfae1afc737b7d8f25801"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1107459fd5f8be596d1f46fd91593f8ede871392d2e88246af23472e951e4c5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "37f8284584929afac535db9d4cd4fe0d4e12b72c5db3c8fb017181e3da52c270"
    sha256 cellar: :any_skip_relocation, ventura:       "1ac4d5b8106797a53f5d0139a4e159dc241b834c0ec8de881b1a9a6123b4d757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "574b4da3fcbf9079cbb56a55b23611343746188e5402f58226466f7b89987285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff3c6351e58440b19265fcfc8107958654442c63cd0268e0e81a23164fff5a9"
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
