class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://github.com/axiros/terminal_markdown_viewer/archive/1.6.0.tar.gz"
  sha256 "20ad41366e0944f627ccc85d91ddc3b72d53cab1501c4930ff24ae30abc64831"

  bottle do
    cellar :any_skip_relocation
    sha256 "c655f19edd87c9679049b7e0f2fa24715c2f64f312730e8bcb360eda60c45e1e" => :sierra
    sha256 "2c672417a5fcf85e3c457fb5a929d3ed2ecb35a4f02e8b2542975830dd6de0f2" => :el_capitan
    sha256 "f308ae4665a24cf07318b5efe75b95a793445037cb17d9deb84eadf78d63ce47" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/d4/32/642bd580c577af37b00a1eb59b0eaa996f2d11dfe394f3dd0c7a8a2de81a/Markdown-2.6.7.tar.gz"
    sha256 "daebf24846efa7ff269cfde8c41a48bb2303920c7b2c7c5e04fa82e6282d05c0"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write <<-EOF.undent
    # Header 1
    ## Header 2
    ### Header 3
    EOF
    system "#{bin}/mdv", "#{testpath}/test.md"
  end
end
