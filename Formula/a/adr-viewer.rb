class AdrViewer < Formula
  include Language::Python::Virtualenv

  desc "Generate easy-to-read web pages for your Architecture Decision Records"
  homepage "https://github.com/mrwilson/adr-viewer"
  url "https://files.pythonhosted.org/packages/1b/72/0f787da38d0f9d69c06b31d8f412735ed4fad383edd7f7d2286f4fc7b5b0/adr_viewer-1.4.0.tar.gz"
  sha256 "9a2f02a9feb3a6d03d055dd8599b20d34126f8e755b4b4ee1a353ecbbd590cef"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84be5edc730293d76c12cbf42eb8429e902aedf01114c1e69099ae111c335935"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5de9ec935b5bdff959017398a1384107fbf1bc7bfc9d30c2c51f6e269e156694"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03ff6ef7bdd353affa19fcefc4ddde2fc3badb970e59636b9a894d917a0bd207"
    sha256 cellar: :any_skip_relocation, sonoma:        "62e5bb46d40598b962ab2f74ebf414f40ab10964d347fd9d6e30a3440f5c141f"
    sha256 cellar: :any_skip_relocation, ventura:       "7f6b9ed8bd14a15f29734739888534eb5573cea5f3d67336e4fe5e2327944ac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eef10318762e64ec17d81d1f32ae925adf8c05a83adfd67c92f4678ba9103101"
  end

  depends_on "python@3.13"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/87/7e/eae463f832f64b3a1cb640384d155079e7dd2905116ab925e9bb04f66e75/bottle-0.13.1.tar.gz"
    sha256 "a48852dc7a051353d3e4de3dd5590cd25de370bcfd94a72237561e314ceb0c88"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/c9/aa/4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39/bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b4/d2/38ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8f/markupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/ef/c8/f0173fe3bf85fd891aee2e7bcd8207dfe26c2c683d727c5a6cc3aec7b628/mistune-3.0.2.tar.gz"
    sha256 "fc7f93ded930c92394ef2cb6f04a8aabab4117a91449e72dcc8dfa646a508be8"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/d7/ce/fbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfb/soupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    adr_dir = testpath/"doc"/"adr"
    mkdir_p adr_dir
    (adr_dir/"0001-record.md").write <<~EOS
      # 1. Record architecture decisions
      Date: 2018-09-02
      ## Status
      Accepted
      ## Context
      We need to record the architectural decisions made on this project.
      ## Decision
      We will use Architecture Decision Records, as [described by Michael Nygard](https://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions).
      ## Consequences
      See Michael Nygard's article, linked above. For a lightweight ADR toolset, see Nat Pryce's [adr-tools](https://github.com/npryce/adr-tools).
    EOS
    system bin/"adr-viewer", "--adr-path", adr_dir, "--output", "index.html"
    assert_predicate testpath/"index.html", :exist?
  end
end
