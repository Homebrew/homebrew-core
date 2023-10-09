class AdrViewer < Formula
  include Language::Python::Virtualenv

  desc "Generate easy-to-read web pages for your Architecture Decision Records"
  homepage "https://github.com/mrwilson/adr-viewer"
  url "https://files.pythonhosted.org/packages/a7/9d/f9fa91d28be99a47bc30abe4eef18052f1745a85cafc6971e4c2855e00c7/adr-viewer-1.3.0.tar.gz"
  sha256 "af936a6c3a3ff10d56a9e9fc970497e147ff56639f787bdf4ddc95d11f3e4ae4"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd7c760f6b3d5720772fe6722f226927a6b5b1ca7d1f4a4b5f058efa24bb14d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e791ad8f2ad9ff0e9c586d97b4a3dbfb1c969315f454f3d63e900dc2665bb5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdbe0e6aaba4a04d2798ebf39afdc3433c07302153d6fefe8fdc193ee69daf6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e28911a829f2eef391d4b319e8843a34119b91d5fefb97cd06548a774613d40"
    sha256 cellar: :any_skip_relocation, ventura:        "20ac16155c9b2efc7fe126f8ffdcb13786effe5db0f75d74cf348b14c3a73f80"
    sha256 cellar: :any_skip_relocation, monterey:       "0cc97504088ca3a89dace6f4875842b78bde01fcb2061c43479603294d3946d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "673ee30b217f61c2f5b56f683fc382dc0c400f0629fa72f493369d6031f4e595"
  end

  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/fd/04/1c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215/bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/10/ed/7e8b97591f6f456174139ec089c769f89a94a1a4025fe967691de971f314/bs4-0.0.1.tar.gz"
    sha256 "36ecea1fd7cc5c0c6e4a1ff075df26d50da647b75376626cc186e2212886dd3a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/ef/c8/f0173fe3bf85fd891aee2e7bcd8207dfe26c2c683d727c5a6cc3aec7b628/mistune-3.0.2.tar.gz"
    sha256 "fc7f93ded930c92394ef2cb6f04a8aabab4117a91449e72dcc8dfa646a508be8"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
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
      We will use Architecture Decision Records, as [described by Michael Nygard](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions).
      ## Consequences
      See Michael Nygard's article, linked above. For a lightweight ADR toolset, see Nat Pryce's [adr-tools](https://github.com/npryce/adr-tools).
    EOS
    system "#{bin}/adr-viewer", "--adr-path", adr_dir, "--output", "index.html"
    assert_predicate testpath/"index.html", :exist?
  end
end
