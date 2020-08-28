class Howdoi < Formula
  include Language::Python::Virtualenv

  desc "Instant coding answers via the command-line"
  homepage "https://github.com/gleitz/howdoi"
  url "https://files.pythonhosted.org/packages/24/24/667a7ec7a5b9ff3d4f6c201426267ba9431d2ecbe79bf9a8ff28b0cb6564/howdoi-2.0.5.tar.gz"
  sha256 "8e4d048ae7ca6182d648f62a66d07360cca2504fe46649c32748b6ef2735f7f4"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "952a24bc41b85fba4bdad71ce377fa133accb78753590e1de745bc2018fa239d" => :catalina
    sha256 "1841ccbd6f6912d5bc1b8ff08d8a765dbd7bc307e6f30d7a65da426a7ce397e1" => :mojave
    sha256 "0c99ea080a74547ad94a69ccf5abe6892c5582e27d659589bd468adfcce623bc" => :high_sierra
  end

  depends_on "python@3.8"

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
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
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
    url "https://files.pythonhosted.org/packages/7e/7b/377b40cb0055bdf1313b743c365b81b9936ad87728a4c51782b4cf131388/keep-2.9.tar.gz"
    sha256 "02b31b65eb4922aa7561068c2fa9c207b9e593702d44056cc1c5d705379b0224"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2c/4d/3ec1ea8512a7fbf57f02dee3035e2cce2d63d0e9c0ab8e4e376e01452597/lxml-4.5.2.tar.gz"
    sha256 "cdc13a1682b2a6241080745b1953719e7fe0850b40a5c71ca574f090a1391df6"
  end

  resource "PyGithub" do
    url "https://files.pythonhosted.org/packages/0e/15/f0f3d504640d2726c017c0c2ae0d21ba2560942ff797f97d3bd6c8535298/PyGithub-1.53.tar.gz"
    sha256 "776befaddab9d8fddd525d52a6ca1ac228cf62b5b1e271836d766f4925e1452e"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/6e/4d/4d2fe93a35dfba417311a4ff627489a947b01dc0cc377a3673c00cf7e4b2/Pygments-2.6.1.tar.gz"
    sha256 "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/2f/38/ff37a24c0243c5f45f5798bd120c0f873eeed073994133c084e1cf13b95c/PyJWT-1.7.1.tar.gz"
    sha256 "8d59a976fb773f3e6a39c85636357c4f0e242707394cadadd9814f5cbaa20e96"
  end

  resource "pyquery" do
    url "https://files.pythonhosted.org/packages/6b/94/4663206f709ac32446e995227cc5be34d5e2aa74ba8f92b8083c2740d3d7/pyquery-1.4.1.tar.gz"
    sha256 "8fcf77c72e3d602ce10a0bd4e65f57f0945c18e15627e49130c27172d4939d98"
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
    url "https://files.pythonhosted.org/packages/81/f4/87467aeb3afc4a6056e1fe86626d259ab97e1213b1dfec14c7cb5f538bf0/urllib3-1.25.10.tar.gz"
    sha256 "91056c15fa70756691db97756772bb1eb9678fa585d9184f24534b100dc60f4a"
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
