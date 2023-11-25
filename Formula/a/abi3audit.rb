class Abi3audit < Formula
  include Language::Python::Virtualenv

  desc "Scans Python packages for abi3 violations and inconsistencies"
  homepage "https://github.com/trailofbits/abi3audit"
  url "https://files.pythonhosted.org/packages/a3/4d/1f08c6db0b6cf02ef0fe33be39144d4477030910c3f61bffa3b2a9b09e87/abi3audit-0.0.9.tar.gz"
  sha256 "4f469e146d911f238724d49fd280d8bb7f411ff5d224865b13e47d4132e776a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32629132628155b7d6912a441572f154a3517d9b766a1715ef60caddc215a2fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b0f331a37688fdf2630bd80d740831b6241438efc8af95926452e0f30f91399"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73e1e88049fde36ac53ea374f296cf5a116e0172e667e24adb8f6ff52a53716a"
    sha256 cellar: :any_skip_relocation, sonoma:         "642f2bfacc6327af8113c09c928ace7aef127edfecc5214f84d2d401da532023"
    sha256 cellar: :any_skip_relocation, ventura:        "2b285f42a7ef2e38b420e896aa8b17669cb6c0cb115a59a1dfbe559962b26410"
    sha256 cellar: :any_skip_relocation, monterey:       "4056acb2d58d05903381a85328f6500f1972ed1da9de8b2633fc35fc8924d576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bb8143edd8abcafd85e0fd1cb3683240809bb611d6d621ed26a7322cad30598"
  end

  depends_on "cmake" => :build
  depends_on "pygments"
  depends_on "python-packaging"
  depends_on "python-requests"
  depends_on "python-rich"
  depends_on "python@3.12"
  depends_on "six"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "rust" => :build
  end

  resource "abi3info" do
    url "https://files.pythonhosted.org/packages/4f/d9/366f6670b677f68c96cb06a5ab58c410be888bcb19bd39743e7e177db9d0/abi3info-2023.10.22.tar.gz"
    sha256 "b02a11119d417e02e2e2ebb0adf247f6796fa19906d2c49926d207b22f19e3ef"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/91/dc/9e8bcf0ee80835cfc7da6d506ccc85ef6cb7a0ea924a61e029ba81093b1a/cattrs-23.2.2.tar.gz"
    sha256 "b790b1c2be1ce042611e33f740e343c2593918bbf3c1cc88cdddac4defc09655"
  end

  resource "kaitaistruct" do
    url "https://files.pythonhosted.org/packages/54/04/dd60b9cb65d580ef6cb6eaee975ad1bdd22d46a3f51b07a1e0606710ea88/kaitaistruct-0.10.tar.gz"
    sha256 "a044dee29173d6afbacf27bcac39daf89b654dd418cfa009ab82d9178a9ae52a"
  end

  resource "pefile" do
    url "https://files.pythonhosted.org/packages/78/c5/3b3c62223f72e2360737fd2a57c30e5b2adecd85e70276879609a7403334/pefile-2023.2.7.tar.gz"
    sha256 "82e6114004b3d6911c77c3953e3838654b04511b8b66e8583db70c65998017dc"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/31/28/e40d24d2e2eb23135f8533ad33d582359c7825623b1e022f9d460def7c05/platformdirs-4.0.0.tar.gz"
    sha256 "cb633b2bcf10c51af60beb0ab06d2f1d69064b43abf4c185ca6b28865f3f9731"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/84/05/fd41cd647de044d1ffec90ce5aaae935126ac217f8ecb302186655284fc8/pyelftools-0.30.tar.gz"
    sha256 "2fc92b0d534f8b081f58c7c370967379123d8e00984deb53c209364efd575b40"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/4d/b6/24aeda90d94fb1fd2cd755d6ce176e526ef61d407f87fd77de6ab0d03157/requests_cache-1.1.1.tar.gz"
    sha256 "764f93d3fa860be72125a568c2cc8eafb151cf29b4dc2515433a56ee657e1c60"
  end

  resource "url-normalize" do
    url "https://files.pythonhosted.org/packages/ec/ea/780a38c99fef750897158c0afb83b979def3b379aaac28b31538d24c4e8f/url-normalize-1.4.3.tar.gz"
    sha256 "d23d3a070ac52a67b83a1c59a0e68f8608d1cd538783b401bc9de2c0fac999b2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/abi3audit sip 2>&1", 1)
    assert_match(/sip: \d+ extensions scanned; \d+ ABI version mismatches and \d+ ABI\s+violations found/, output)
  end
end
