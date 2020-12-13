class Howdoi < Formula
  include Language::Python::Virtualenv

  desc "Instant coding answers via the command-line"
  homepage "https://github.com/gleitz/howdoi"
  url "https://files.pythonhosted.org/packages/a4/20/09fad4f722863494d075c1c5deb1b448042c65af99bf20d4d28274cefbd8/howdoi-2.0.8.tar.gz"
  sha256 "9b7cabab87cd614e26b408653bc8937ec27b79ca2fde6b9457da55d2541f75fb"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "aa86c1fa0345111740e666035055eece0970a868eb9c8b00293beaae6514e4c3" => :big_sur
    sha256 "0a683665c2e322649885a5c2070aa6305cf569cf53879af9d88a1c9e0036fdf6" => :catalina
    sha256 "d9c55a11f68323c81c31c3bf19279ca7ca492ca64ac31626b63a908a13591715" => :mojave
    sha256 "d66437ecf7679c576c2ecb5a230a4d0dfd3eaa87de5e89b8392c00aa53dfc833" => :high_sierra
  end

  depends_on "python@3.9"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "cachelib" do
    url "https://files.pythonhosted.org/packages/e6/5b/39d1f9071e95123a4ae6d8bdeb53416d1af601f662641eac9b0d7c844dba/cachelib-0.1.tar.gz"
    sha256 "8b889b509d372095357b8705966e1282d40835c4126d7c2b07fd414514d8ae8d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/70/54/37630f6eb2c214cdee2ae56b7287394c8aa2f3bafb8b4eb8c3791aae7a14/cssselect-1.1.0.tar.gz"
    sha256 "f95f8dedd925fd8f54edb3d2dfb44c190d9d18512377d3c1e2388d16126879bc"
  end

  resource "Deprecated" do
    url "https://files.pythonhosted.org/packages/c1/2d/60b1be29720ea1a3d3146fac1a596875622ae8dcb40cf926cc4759dadfd6/Deprecated-1.2.10.tar.gz"
    sha256 "525ba66fb5f90b07169fdd48b6373c18f1ee12728ca277ca44567a367d9d7f74"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "keep" do
    url "https://files.pythonhosted.org/packages/b9/c5/408a6ef63285639874d433eea0a6a6189837ff2fc7e7cb2f842e47037073/keep-2.10.tar.gz"
    sha256 "ce71d14110df197ab5afdbd26a14c0bd266b79671118ae1351835fa192e61d9b"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/db/f7/43fecb94d66959c1e23aa53d6161231dca0e93ec500224cf31b3c4073e37/lxml-4.6.2.tar.gz"
    sha256 "cd11c7e8d21af997ee8079037fff88f16fda188a9776eb4b81c7e4c9c0a7d7fc"
  end

  resource "PyGithub" do
    url "https://files.pythonhosted.org/packages/2c/9c/2df0cad1eb058efc15fd435e825c88748ace27e279743d444d84f8f90dd6/PyGithub-1.54.tar.gz"
    sha256 "14c96d55e3c0e295598e52fbbbf2a7862a293723482ae9000cb9c816faab4fb4"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/29/60/8ff9dcb5eac7f4da327ba9ecb74e1ad783b2d32423c06ef599e48c79b1e1/Pygments-2.7.3.tar.gz"
    sha256 "ccf3acacf3782cbed4a989426012f1c535c9a90d3a7fc3f16d231b9372d2b716"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/2f/38/ff37a24c0243c5f45f5798bd120c0f873eeed073994133c084e1cf13b95c/PyJWT-1.7.1.tar.gz"
    sha256 "8d59a976fb773f3e6a39c85636357c4f0e242707394cadadd9814f5cbaa20e96"
  end

  resource "pyquery" do
    url "https://files.pythonhosted.org/packages/e9/27/6db65c90587856a229539df703679fa81d17089b74432abfd74a0dd2ca13/pyquery-1.4.3.tar.gz"
    sha256 "a388eefb6bc4a55350de0316fbd97cda999ae669b6743ae5b99102ba54f5aa72"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/9b/c4/4a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bff/terminaltables-3.1.0.tar.gz"
    sha256 "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/76/d9/bbbafc76b18da706451fa91bc2ebe21c0daf8868ef3c30b869ac7cb7f01d/urllib3-1.25.11.tar.gz"
    sha256 "8d7eaa5a82a1cac232164990f04874c594c9453ec55eef02eab885aa02fc17a2"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/82/f7/e43cefbe88c5fd371f4cf0cf5eb3feccd07515af9fd6cf7dbf1d1793a797/wrapt-1.12.1.tar.gz"
    sha256 "b62ffa81fb85f4332a4f609cab4ac40709470da05643a082ec1eb88e6d9b97d7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "sqrt", shell_output("#{bin}/howdoi square root ruby")

    assert_match "# put current date as yyyy-mm-dd in $date",
      shell_output("#{bin}/howdoi format date bash 2>&1")
  end
end
