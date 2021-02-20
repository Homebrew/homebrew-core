class Howdoi < Formula
  include Language::Python::Virtualenv

  desc "Instant coding answers via the command-line"
  homepage "https://github.com/gleitz/howdoi"
  url "https://files.pythonhosted.org/packages/6a/ce/beb25c37546afd5cb91318ed26c4f19af994cd059bc6d1ed75261422d005/howdoi-2.0.12.tar.gz"
  sha256 "bab3eab349ec0b534cf1b05a563d45e4d301b914c53a7f2c3446fdcc60497c93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef54659de200e0dfe8f21df996dc44cdeba26f817c149582a7313653657176d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "2e0e8ad772a7bf61bae5db97fa55470a6ff65155e9b6a6e5d19b3765564ccefa"
    sha256 cellar: :any_skip_relocation, catalina:      "182c3080b03158638c0ab375d9b66ada2f6a19119f6145a90abec56bc7c4e0a9"
    sha256 cellar: :any_skip_relocation, mojave:        "dea015344f0892eb4020896f4e6e66fee588c6e59ab39269655446743c686016"
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
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
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
    url "https://files.pythonhosted.org/packages/bf/f0/e5b25225d86b4ac205fdf4495ab1e0f120a0742bb1ccb488daf4eaf67079/Deprecated-1.2.11.tar.gz"
    sha256 "471ec32b2755172046e28102cd46c481f21c6036a0ec027521eba8521aa4ef35"
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
    url "https://files.pythonhosted.org/packages/6f/d6/831918fd574b687e7aa3caada99ce7c7c917275677a04c373631ff974be7/PyGithub-1.54.1.tar.gz"
    sha256 "300bc16e62886ca6537b0830e8f516ea4bc3ef12d308e0c5aff8bdbd099173d4"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/19/d0/dec5604a275b19b0ebd2b9c43730ce39549c8cd8602043eaf40c541a7256/Pygments-2.8.0.tar.gz"
    sha256 "37a13ba168a02ac54cc5891a42b1caec333e59b66addb7fa633ea8a6d73445c0"
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
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/9b/c4/4a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bff/terminaltables-3.1.0.tar.gz"
    sha256 "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d7/8d/7ee68c6b48e1ec8d41198f694ecdc15f7596356f2ff8e6b1420300cf5db3/urllib3-1.26.3.tar.gz"
    sha256 "de3eedaad74a2683334e282005cd8d7f22f4d55fa690a2a1020a416cb0a47e73"
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
