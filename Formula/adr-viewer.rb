class AdrViewer < Formula
  include Language::Python::Virtualenv

  desc "Generate easy-to-read web pages for your Architecture Decision Records"
  homepage "https://github.com/mrwilson/adr-viewer"
  url "https://files.pythonhosted.org/packages/a7/9d/f9fa91d28be99a47bc30abe4eef18052f1745a85cafc6971e4c2855e00c7/adr-viewer-1.3.0.tar.gz"
  sha256 "af936a6c3a3ff10d56a9e9fc970497e147ff56639f787bdf4ddc95d11f3e4ae4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5f4f03e050f02f910d3bf2d6a59c548926dfd3984769bb765b2078a6dc36444"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "662edfd417b450c86b4e7e466d7d0b238eafa79b7390cdda6db7318592fffbb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc0056ec85ae8e7d337212989d2545bb85fc6c6d86cb6591c687fd5204905b9a"
    sha256 cellar: :any_skip_relocation, ventura:        "9b6515a202d51a07b7ee99539b4418ada56e8666b6566ef49bb970aa519b49fa"
    sha256 cellar: :any_skip_relocation, monterey:       "c48703b191914a07393cc44051ae9c2fa2fcfd3eb5b4c0ce06f07fc1b28836a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fa60fb1ffd33f03e899a3f85533f326c6e1ebdb29f1ea92aeabe6acf456b29e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1304be0eb77dcfad374566b67f29a513fdc69863eaed9c49837a8dc8f9caed6c"
  end

  depends_on "python@3.11"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/75/f8/de84282681c5a8307f3fff67b64641627b2652752d49d9222b77400d02b8/beautifulsoup4-4.11.2.tar.gz"
    sha256 "bc4bdda6717de5a2987436fb8d72f45dc90dd856bdfd512a1314ce90349a0106"
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
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/fb/6b/d8013058fcdb0088b4130164fc961e15c50d30302f60a349c16bdfda9770/mistune-2.0.5.tar.gz"
    sha256 "0246113cb2492db875c6be56974a7c893333bf26cd92891c85f63151cee09d34"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/1b/cb/34933ebdd6bf6a77daaa0bd04318d61591452eb90ecca4def947e3cb2165/soupsieve-2.4.tar.gz"
    sha256 "e28dba9ca6c7c00173e34e4ba57448f0688bb681b7c5e8bf4971daafc093d69a"
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
