class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v1.1.1730.tar.gz"
  sha256 "f5efb0180adce75cafcbf9413ab86c6826ea37052996b68e6e6763140ce6b6b2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6590a077fdafd0f2449c5b431cea4115a98314dda9a5efece72ee7b5047adaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc1642722f09ab9e5e4563c33a98199951af0f6f78943e355acfcf229ad59c55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "221a125290c45f74c4dc350c5b14ee2788cd2e84affb7a2a52f69528854118c0"
    sha256 cellar: :any_skip_relocation, ventura:        "0b4f8233806071573f94cc303fd3971264f8689b8fde545e89f4f3d34940cd71"
    sha256 cellar: :any_skip_relocation, monterey:       "46959f98570738e5dde346a2af86e246ba73414cbd8080b166864f2aae9046e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "811e1eef4c43312864519e28e8c3353bbe7cca8d4f2c52aeabbce239163aa0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2145bdf039dd0451ab09bd1956a85031dc6e50963ff70174cadc1b0fbf1de617"
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
