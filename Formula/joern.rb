class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v1.1.1570.tar.gz"
  sha256 "2210cff96be19edec93e8cc2c4ca2948b7a2902490cf7e55ab9d56a653a9a00f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf02f9ae2543ef1f2e9f52b3a4ddc34173dc73562da42d58143a1c8f0d6afbb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "097b7fc0e1bda5d7c109f6a46fd01e15fa1d37942c2f34f6af16c085daa3920b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1e2fcb49259aeebb7370414d72fa3f6714a4f6fd1702f6c4ed961a7733ba7e8"
    sha256 cellar: :any_skip_relocation, ventura:        "abff8a4c95ab1e9aeef47f9febc2297e44008f9f18b30fd9206e1b268fc98944"
    sha256 cellar: :any_skip_relocation, monterey:       "6d2fec1b7fd31bebaa9d9ce29d0e1edc311ab9ac9d7fd592bec49e3e147e757c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c08ee413ae35b3019377d57709196b64797589ddd42d0c673faa24710da0a3de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f983f56c4a90b6b1ee2ea3bacfe2836672896d145d745f4f686fb3a4035892f"
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
