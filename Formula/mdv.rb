class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://files.pythonhosted.org/packages/c8/94/931f2b9bae37acbe8de987884fc7a8a8981de6efc3ef9276d23b967f6c15/mdv-1.4.1.tar.gz"
  sha256 "8792cd42c24445007b7eb6ad3ab28483ab6e47f2d6a5fe408e69b62bc83a567a"

  bottle do
    sha256 "454220cd1377ac315ee5ca5ed484f8e150d261bc50f1153e925d03f418f01b89" => :sierra
    sha256 "9cacb9d0db26e8d1898a9b4fe1045063a821bd1b79c6e35f8b6b09be54126ee9" => :el_capitan
    sha256 "dbbead980818a33d58c2e4f1ac4f0834c10aa8a8b483692457f0e40ff0291070" => :yosemite
  end

  depends_on :python

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
