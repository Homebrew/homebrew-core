class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://files.pythonhosted.org/packages/70/6d/831e188f8079c9793eac4f62ae55d04a93d90979fd2d8271113687605380/mdv-1.7.4.tar.gz"
  sha256 "1534f477c85d580352c82141436f6fdba79d329af8a5ee7e329fea14424a660d"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6794a4864eeae9e1e805700605fa80610da626f48e586744535ce00d8b88f21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81ef8f08570dbd4af753403e58d266fa2e4b440db92fb9b4506a92e9bd6de100"
    sha256 cellar: :any_skip_relocation, monterey:       "68cc02cf881189ed510e2a5beff7de61217ce316c8aba28819cdb25d6da3838f"
    sha256 cellar: :any_skip_relocation, big_sur:        "04e3e87af387732342c4674feeb11b493090eb6504d4c6797b57f41bbf9a90a8"
    sha256 cellar: :any_skip_relocation, catalina:       "ba336eac38af86dd98d74dbba06226d13b0bc8af719e1e40a863f9f394da4de8"
    sha256 cellar: :any_skip_relocation, mojave:         "ecb421e63e0278668ae2d570c8095186cb3e4695c5ba9891f20d16c2ba3c6e6c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "3b9847a65d7c9820148cd848687efdb598193cc76abb031c1f71841bad2ec60d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0bdd4c19f2486841a91bbf3a13eb69d46b6b77d729abd870a05430c19d8be6b"
  end

  depends_on "python@3.8"

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/d6/58/79df20de6e67a83f0d0bbfe6c19bb82adf68cdf362885257eb01099f930a/Markdown-3.3.7.tar.gz"
    sha256 "cbb516f16218e643d8e0a95b309f77eb118cb138d39a4f27851e6a63581db874"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ae/3d/9d7576d94007eaf3bb685acbaaec66ff4cdeb0b18f1bf1f17edbeebffb0a/tabulate-0.8.9.tar.gz"
    sha256 "eb1d13f25760052e8931f2ef80aaf6045a6cceb47514db8beab24cded16f13a7"
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
