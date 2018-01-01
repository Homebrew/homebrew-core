class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://github.com/axiros/terminal_markdown_viewer/archive/1.6.3.tar.gz"
  sha256 "58dbdf8c051a2d7f8c00e4dc13c655c335cbc2bc96851dd0388d73a21c4507b6"

  bottle do
    cellar :any_skip_relocation
    sha256 "94a95cabd6f75d33d7d91d5b4304a77a0a068ff6abb15d36b92565ba966eef7c" => :high_sierra
    sha256 "85fe18363a3c8b9f56526a6cf0d2bde2eb212cbb80ba8f1175a646c749f50ced" => :sierra
    sha256 "5c371c8a9313f7cd8104d23978217916b2991d02da9605b2798d9d292b15f118" => :el_capitan
    sha256 "d2ac3612660964bc8a33780f50c076ce884094735b3f1cc3686ac606c154af13" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard

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
    (testpath/"test.md").write <<~EOS
      # Header 1
      ## Header 2
      ### Header 3
    EOS
    system "#{bin}/mdv", "#{testpath}/test.md"
  end
end
