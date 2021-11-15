class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https://github.com/hylang/hy"
  url "https://files.pythonhosted.org/packages/2d/80/c9de6ace090a06f42ef68e746f1430d0074a33d21e46839813c764934d64/hy-0.20.0.tar.gz"
  sha256 "1b72863754fb57e2dd275a9775bf621cb50a565e76733a2e74e9954e7fbb060e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00f15f27bd30f78a786f2eeba4003709c8a3ca3804447e8459ae9f19e06cb383"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98b24099b57bdb1322de0e0a20885853a3cc6ddeeb21b833293c3372a600f005"
    sha256 cellar: :any_skip_relocation, monterey:       "4ffdb327dcea3f6e0701efcb105170080503ec1fc001d4fb1ea5c0052dcd57ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3a8611e5647203bc52944ae8c3a7fb1c105e1dda9d65a6641fef45edfc1f48c"
    sha256 cellar: :any_skip_relocation, catalina:       "b8f9062329e87549cc63f63712e0a5790d9722905fd15765d82f997296f49c58"
    sha256 cellar: :any_skip_relocation, mojave:         "30734f23d8c216671a4eb3b8595288354e8f00f31da0da76f9022595c3daf496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7e161e87fe9e19ee309ddfceb1cfb56f9d16394cff58b402b920f75e0ef0bc6"
  end

  depends_on "python@3.9"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "astor" do
    url "https://files.pythonhosted.org/packages/5a/21/75b771132fee241dfe601d39ade629548a9626d1d39f333fde31bc46febe/astor-0.8.1.tar.gz"
    sha256 "6a6effda93f4e1ce9f618779b2dd1d9d84f1e32812c23a29b3fff6fd7f63fa5e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "funcparserlib" do
    url "https://files.pythonhosted.org/packages/cb/f7/b4a59c3ccf67c0082546eaeb454da1a6610e924d2e7a2a21f337ecae7b40/funcparserlib-0.3.6.tar.gz"
    sha256 "b7992eac1a3eb97b3d91faa342bfda0729e990bd8a43774c1592c091e563c91d"
  end

  resource "rply" do
    url "https://files.pythonhosted.org/packages/71/04/e52242871e606389f232f07042747567fb354a91d9449cad7fa9febbe3b3/rply-0.7.7.tar.gz"
    sha256 "4d6d25703efd28fb3d5707f7b3bd4fe66c306159a5c25af10ba26d206a66d00d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.hy").write "(print (+ 2 2))"
    assert_match "4", shell_output("#{bin}/hy test.hy")
    (testpath/"test.py").write shell_output("#{bin}/hy2py test.hy")
    assert_match "4", shell_output("#{Formula["python@3.9"].bin}/python3 test.py")
  end
end
