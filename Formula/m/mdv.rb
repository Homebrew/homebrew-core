class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  # TODO: Remove `depends_on "python-tabulate"` on the next release
  # Ref: https://github.com/axiros/terminal_markdown_viewer/commit/d2e8d26f39590fdc9c0b9ec0b80b578c7e260c6c
  url "https://files.pythonhosted.org/packages/70/6d/831e188f8079c9793eac4f62ae55d04a93d90979fd2d8271113687605380/mdv-1.7.4.tar.gz"
  sha256 "1534f477c85d580352c82141436f6fdba79d329af8a5ee7e329fea14424a660d"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86c5e40583cfc1ef7eb3c6d7018c583fc6f4367ffdb17b5cfcc0fa56243e880c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9142eb09dfabac520788ef54edd381ef502a212f17ef19b60d44fe3dd0043703"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "821062b5e21a8a9f40a436f8c519f79f37cb388b8b18a328122627ee2deeba77"
    sha256 cellar: :any_skip_relocation, ventura:        "cf6c06afc79b496389ab63a5dc889247db69d3cf989e0c84d053e628d6fe4937"
    sha256 cellar: :any_skip_relocation, monterey:       "56998e7ede36db96d375024160d0395a145e6eb4e505aba865d0150f086d41de"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e481631fad73db799d6aefd0e76ae504f30d4723dc13c83da4e079ccf417c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98aaa2c71d47a881ab002a879b421de18fb023efc9452262f8d9b396414a064a"
  end

  depends_on "pygments"
  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/d6/58/79df20de6e67a83f0d0bbfe6c19bb82adf68cdf362885257eb01099f930a/Markdown-3.3.7.tar.gz"
    sha256 "cbb516f16218e643d8e0a95b309f77eb118cb138d39a4f27851e6a63581db874"
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
