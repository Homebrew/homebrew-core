class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "66dd70fb144aec14e42119dacbcf5a538cff77246737ddde728ff30c35ad3fa2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6199e3e52d052dc6ce606b85fb2f1b07442ae454e8399055ee6ad42ff93d3df5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6199e3e52d052dc6ce606b85fb2f1b07442ae454e8399055ee6ad42ff93d3df5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6199e3e52d052dc6ce606b85fb2f1b07442ae454e8399055ee6ad42ff93d3df5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c372c254136bab984fd7f10b62c1906449d680c729fbe57b62fcafcfdce2f6ed"
    sha256 cellar: :any_skip_relocation, ventura:       "c372c254136bab984fd7f10b62c1906449d680c729fbe57b62fcafcfdce2f6ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13abacc9c49693cc929212564edab4da36b56403a882e75b25887506627b40f9"
  end

  depends_on "go" => :build

  def install
    cd "src/gabo" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gabo"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gabo --version")

    gabo_test = testpath/"gabo-test"
    gabo_test.mkpath
    (gabo_test/".git").mkpath # Emulate git
    system bin/"gabo", "-dir", gabo_test, "-for", "lint-yaml", "-mode=generate"
    assert_predicate gabo_test/".github/workflows/lint-yaml.yaml", :exist?
  end
end
