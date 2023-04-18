class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/65/0e/f3ecc15f1f9dbd95ecdf1cd3246712ae13920d9665c3dbed089cd5d12d3b/MapProxy-1.16.0.tar.gz"
  sha256 "a11157be4729d1ab40680af2ce543fffcfebd991a5fa676e3a307a93fbc56d6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "357409c42e963452eee917aba714c327e90935208f8c2ac20fdaa885a68e4362"
    sha256 cellar: :any,                 arm64_monterey: "4a52631dabb041f43107d324effb5d7853cae5723d6a108aaf2dfa401205cb8e"
    sha256 cellar: :any,                 arm64_big_sur:  "6ffbb7b6840855a29e3772f3738bbf898783c6834d0d11de53fcf4897c97ecfe"
    sha256 cellar: :any,                 ventura:        "2f8bf785d7b627f7ba12ada9b4d027b6db862f24f064c41c0111f44f1608a82d"
    sha256 cellar: :any,                 monterey:       "14d624c9231313e60d5641a386e15cd867ca2956efd81c82035cac1de9209b29"
    sha256 cellar: :any,                 big_sur:        "678b2bb6e1f292dc6837b7707e04d58894c320aa472e3871b607b9222c293377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd316d989e802fcc2d717e0705ee7d4a51eaa03007b649be89b630e4d7ede241"
  end

  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/9c/f5/cd9371194d3c939dffddff9e118a018bb7c2f560549bea4c6bc21b24eadd/pyproj-3.5.0.tar.gz"
    sha256 "9859d1591c1863414d875ae0759e72c2cffc01ab989dc64137fbac572cc81bf6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end
