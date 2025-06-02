class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.360.tar.gz"
  sha256 "5a0e9eff10dedd72bb2119ffe7243bac05b052d78ba3ec9ed73926c4c062bb13"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5f8d8896e28da6803bc95604b42ec8f11abe06b174bcf13264802cd98ecc537"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3294cf9c1394c8e9013f3e57329958733e933534d12a54d14a39e72c00be0782"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0178e8e69b929aff9568ae1ef7af150ad1b6c8e5a688d98c5177c8e085544589"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e76d62753e04fbebacd1cde67c698f962a38df6c2aa5184bd64e3c4883f87ce"
    sha256 cellar: :any_skip_relocation, ventura:       "1ccb22cb34222a5cbb7501f9d737931a19202fc65d2b2a512025c07e69d58409"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da63cf8e28be60316c3f37c3e6301fd81236432e2aaa46e432a151631eb0e6f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1607bddd08fab585aa1ee0b3830ea522651b307e146999bc35ed4ca12360b73"
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
