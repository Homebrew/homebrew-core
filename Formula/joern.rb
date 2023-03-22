class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v1.1.1539.tar.gz"
  sha256 "22e5a843f54031a280cbacdcf31a1c2eabc91654e6fffebf0b566a3295528fd0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "293765e257552d4d0c26dcb9e3b1e664b348166f58b53282dc80e80adf6d3f05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcf4fa3178cff8ba2aa005c55db953307d1ff7c183f4e2242940b5003e88fb8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "610a8c11eab4d63e978e7eb99e12825cdf4a17ee56aa29aa1c8786d1a11d395e"
    sha256 cellar: :any_skip_relocation, ventura:        "9c0473419798a9060f7fb5996a023842f1ecf8888550cfc6ee24650020d000be"
    sha256 cellar: :any_skip_relocation, monterey:       "76ef96f56b16a6469ce6e7caabf0ca51afc6e0cb6a9c9c0cd2d35e624daf143f"
    sha256 cellar: :any_skip_relocation, big_sur:        "901fd630154114cabc17266618ac6e806aaf13c0cd01a9b011a2e17aedf99a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9544c8a6038a885d81ee046bb3cfdfea7d905e69dbfc667c070700636092828"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk@17"
  depends_on "php"

  def install
    system "sbt", "stage"

    cd "joern-cli/target/universal/stage" do
      rm_f Dir["**/*.bat"]
      libexec.install Pathname.pwd.children
    end

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (bin/f.basename).write_env_script f, Language::Java.overridable_java_home_env("17")
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      void print_number(int x) {
        std::cout << x << std::endl;
      }

      int main(void) {
        print_number(42);
        return 0;
      }
    EOS

    assert_match "Parsing code", shell_output("#{bin}/joern-parse test.cpp")
    assert_predicate testpath/"cpg.bin", :exist?
  end
end
