class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/91/93/f089b5691636d8fe09476d5ee16df5f8f8ea6fdcd9fa55786e933c4c7802/dxpy-0.404.0.tar.gz"
  sha256 "04ed9f8aa2ddc0c2a843ce0ee934e8f31af62c8e56e5e1cf42cad86118fa6d6d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5665e7497de4645548f1497c82da854ccd3c1671417e2f920d69d2a301d37860"
    sha256 cellar: :any,                 arm64_sequoia: "a39a274ab6a49d44ed3d53093b7c56bff3f3c91771b6f25d8b9bab7ce2a963b6"
    sha256 cellar: :any,                 arm64_sonoma:  "d7077ac3c3ba0be2a1a7fe7bbda6408c75c822df42b9d228076bab6500545c21"
    sha256 cellar: :any,                 sonoma:        "d927a4f38b2efbd2dcb6ab38fab3c4986d773590dcd52a990ec026a0a573964b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12e4814424edb8cc6e2c2e0578a110b0fe5be2e3976a53f2f797bb5f43687ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9651c73dafa71f2dd737e603ead773efc5f666134158dfee581b9f34a5adea0"
  end

  depends_on "cmake" => :build # for awscrt
  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-compression"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-mqtt"
  depends_on "aws-c-s3"
  depends_on "aws-c-sdkutils"
  depends_on "aws-checksums"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "openssl@3"
  depends_on "python@3.14"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline" => :no_linkage
  end

  on_linux do
    depends_on "aws-lc"
    depends_on "s2n"
  end

  pypi_packages exclude_packages: %w[cryptography certifi]

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/35/c9/8e397a679f43c53cb51b338bda2645e8a474c9a4dd5606d0ee365b7b5fbc/awscrt-0.31.1.tar.gz"
    sha256 "abb64768d25bf563da8e2165d477a491cba18bc22c4ec8db7acbdae94e59ebc4"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/e3/66/7e97aa77af7cf6afbff26e3651b564fe41932599bc2d3dce0b2f73d4829a/crc32c-2.8.tar.gz"
    sha256 "578728964e59c47c356aeeedee6220e021e124b9d3e8631d95d9a5e5f06e261c"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/20/07/2a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330/websocket-client-1.7.0.tar.gz"
    sha256 "10e511ea3a8c744631d3bd77e61eb17ed09304c413ad42cf6ddfa4c7787e8fe6"
  end

  def install
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBCRYPTO"] = "1"
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBS"] = "1"

    virtualenv_install_with_resources
  end

  test do
    dxenv = <<~EOS
      API server protocol	https
      API server host		api.dnanexus.com
      API server port		443
      Current workspace	None
      Current folder		None
      Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end
