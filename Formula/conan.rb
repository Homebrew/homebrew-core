class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://conan.io"
  url "https://files.pythonhosted.org/packages/3b/a5/627a51563ac3e1164e1d2ee8995e714f93e00be696f8153ef840bee7797e/conan-1.37.0.tar.gz"
  sha256 "2a5e7f872906912f0b22751046b11397f73dc92602cb87dd2089842d476fb767"
  license "MIT"
  head "https://github.com/conan-io/conan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a43800cb21ed8e4b7be790af5f95b457eae86d2a6e3f5094620e2a4c1a399a62"
    sha256 cellar: :any_skip_relocation, big_sur:       "15bc3d0deb5808ab4bcb2b3156b24a234b557fc6349c536e56c5d01696b2d362"
    sha256 cellar: :any_skip_relocation, catalina:      "05fa3e16936a1f5f07a92f23b004eef64115ff571a93c917058d9e73e2be74dc"
    sha256 cellar: :any_skip_relocation, mojave:        "c083ad6380ef25bf8a6565c596c336f532e09341000abede9ca8d67ea983514d"
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/ea/80/3d2dca1562ffa1929017c74635b4cb3645a352588de89e90d0bb53af3317/bottle-0.12.19.tar.gz"
    sha256 "a9d73ffcbc6a1345ca2d7949638db46349f5b2b77dac65d6494d45c23628da2c"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/cd/94/8d9d6303f5ddcbf40959fc2b287479bd9a201ea9483373d9b0882ae7c3ad/deprecation-2.0.7.tar.gz"
    sha256 "c0392f676a6146f0238db5744d73e786a43510d54033f80994ef2f4c9df192ed"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a6/a4/75064c334d8ae433445a20816b788700db1651f21bdb0af33db2aab142fe/distro-1.5.0.tar.gz"
    sha256 "0e58756ae38fbd8fc3020d54badb8eae17c5b9dcbed388b17bb55b8a5928df92"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/d1/8f/a6c06f9bce5691a40283e52b92ec1522d6863951e738a31b109bf6bf2002/fasteners-0.16.tar.gz"
    sha256 "c995d8c26b017c5d6a6de9ad29a0f9cdd57de61ae1113d28fac26622b06a0933"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "node-semver" do
    url "https://files.pythonhosted.org/packages/f1/4e/1d9a619dcfd9f42d0e874a5b47efa0923e84829886e6a47b45328a1f32f1/node-semver-0.6.1.tar.gz"
    sha256 "4016f7c1071b0493f18db69ea02d3763e98a633606d7c7beca811e53b5ac66b7"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "patch-ng" do
    url "https://files.pythonhosted.org/packages/c1/b2/ad3cd464101435fdf642d20e0e5e782b4edaef1affdf2adfc5c75660225b/patch-ng-1.17.4.tar.gz"
    sha256 "627abc5bd723c8b481e96849b9734b10065426224d4d22cd44137004ac0d4ace"
  end

  resource "pluginbase" do
    url "https://files.pythonhosted.org/packages/f3/07/753451e80d2b0bf3bceec1162e8d23638ac3cb18d1c38ad340c586e90b42/pluginbase-1.0.1.tar.gz"
    sha256 "ff6c33a98fce232e9c73841d787a643de574937069f0d18147028d70d7dee287"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/2f/38/ff37a24c0243c5f45f5798bd120c0f873eeed073994133c084e1cf13b95c/PyJWT-1.7.1.tar.gz"
    sha256 "8d59a976fb773f3e6a39c85636357c4f0e242707394cadadd9814f5cbaa20e96"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/06/ca/721a7abe555012efaa4d6ee18a0048a4f27d84c6220bb6aa6eba049117d6/tqdm-4.61.0.tar.gz"
    sha256 "cd5791b5d7c3f2f1819efc81d36eb719a38e0906a7380365c556779f585ea042"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/76/d9/bbbafc76b18da706451fa91bc2ebe21c0daf8868ef3c30b869ac7cb7f01d/urllib3-1.25.11.tar.gz"
    sha256 "8d7eaa5a82a1cac232164990f04874c594c9453ec55eef02eab885aa02fc17a2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
