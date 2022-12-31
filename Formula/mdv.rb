class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  # TODO: Remove `depends_on "python-tabulate"` on the next release
  # TODO: Remove "Markdown==2.6.11" and "tabulate" from pypi_formula_mappings.json on the next release
  # Ref: https://github.com/axiros/terminal_markdown_viewer/commit/d2e8d26f39590fdc9c0b9ec0b80b578c7e260c6c
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

  depends_on "pygments"
  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/b3/73/fc5c850f44af5889192dff783b7b0d8f3fe8d30b65c8e3f78f8f0265fecf/Markdown-2.6.11.tar.gz"
    sha256 "a856869c7ff079ad84a3e19cd87a64998350c2b94e9e08e44270faef33400f81"
  end

  # Upstream fix for code blocks not being indexed like expected.
  # Patching this in allows directly applying Python 3.9 fix in subsequent patch.
  # Issue ref: https://github.com/axiros/terminal_markdown_viewer/issues/66
  # TODO: Remove in the next release
  patch do
    url "https://github.com/axiros/terminal_markdown_viewer/commit/80f333ba51dc2f1dfa854e203d3374a112aecbd3.patch?full_index=1"
    sha256 "81e487a8e6ab5c72298186a8097da3a962549b6b8112241cccbeb1666ce54cf2"
  end

  # Upstream fix for Python 3.9 support.
  # Issue ref: https://github.com/axiros/terminal_markdown_viewer/issues/86
  # TODO: Remove in the next release
  patch do
    url "https://github.com/axiros/terminal_markdown_viewer/commit/aa6f377d568a0d3188b624bf5218af002373ad87.patch?full_index=1"
    sha256 "500ddecd02c093cff32edc704628612c8f82e1298452a278cd00767daa073fbe"
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
