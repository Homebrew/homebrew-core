class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v1.1.1540.tar.gz"
  sha256 "f2e0c8b2639ba087d8cb4065c56a11d42f115d16e7ad12c629465d5624bafd54"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c60dd6bebd73efdacc6c57692c0c83cb5a5e72c2c5d21f25f1cf6e3140b9ada"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffd13b09980d5b51d5952182c7941b5c7943cd3ee74386788a75692b541ea010"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bba8c955a58b7f15e6556f78ffd52bc79f23f29ef68007a9664a64bd24e27756"
    sha256 cellar: :any_skip_relocation, ventura:        "70efa83081de1b0a4a06900ab64f0f4a67e8106be7b86940077668a077f7ea56"
    sha256 cellar: :any_skip_relocation, monterey:       "e12ff3e66f26538592d4e285d7f111301ac4cd3a88c52412231458e54f6ea9c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0d8f60200ee804e265cf7abede4ec07381143b6bee085472a90729f7c6bf49d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f3f037f4d1c330df5c1e43bd8bc320625eccc6d624b11e23a7a9e2425d0d88d"
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
