class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://files.pythonhosted.org/packages/70/6d/831e188f8079c9793eac4f62ae55d04a93d90979fd2d8271113687605380/mdv-1.7.4.tar.gz"
  sha256 "1534f477c85d580352c82141436f6fdba79d329af8a5ee7e329fea14424a660d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7689a64f112b66c3ea5d283ed59d44b9d482d360c4dd8c41b60a5cbeca8d328c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6794a4864eeae9e1e805700605fa80610da626f48e586744535ce00d8b88f21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81ef8f08570dbd4af753403e58d266fa2e4b440db92fb9b4506a92e9bd6de100"
    sha256 cellar: :any_skip_relocation, ventura:        "9fc8fb8224a73aab80444013474c9e0057147452ac60c87054f39c3104d7a691"
    sha256 cellar: :any_skip_relocation, monterey:       "68cc02cf881189ed510e2a5beff7de61217ce316c8aba28819cdb25d6da3838f"
    sha256 cellar: :any_skip_relocation, big_sur:        "04e3e87af387732342c4674feeb11b493090eb6504d4c6797b57f41bbf9a90a8"
    sha256 cellar: :any_skip_relocation, catalina:       "ba336eac38af86dd98d74dbba06226d13b0bc8af719e1e40a863f9f394da4de8"
    sha256 cellar: :any_skip_relocation, mojave:         "ecb421e63e0278668ae2d570c8095186cb3e4695c5ba9891f20d16c2ba3c6e6c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "3b9847a65d7c9820148cd848687efdb598193cc76abb031c1f71841bad2ec60d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0bdd4c19f2486841a91bbf3a13eb69d46b6b77d729abd870a05430c19d8be6b"
  end

  depends_on "python@3.8"

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
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/57/6f/213d075ad03c84991d44e63b6516dd7d185091df5e1d02a660874f8f7e1e/tabulate-0.8.7.tar.gz"
    sha256 "db2723a20d04bcda8522165c73eea7c300eda74e0ce852d9022e0159d7895007"
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
