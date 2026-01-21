class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/0b/b8/b25a425d2a31dd8324b6b356d06c33ccfe6a1a80518e5e0d4d6f6addf0b1/dxpy-0.402.0.tar.gz"
  sha256 "ae3d43ac10b54162b2b51e646e3054d9824af251f771f2a846776087141e9198"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d4ac68826f96569ac975f7d736d00595175a0f3197f60c6601b09ee66b02b42"
    sha256 cellar: :any,                 arm64_sequoia: "232a6a654d9d2792df172be5dba831550138580580254881d375c852ef58ef57"
    sha256 cellar: :any,                 arm64_sonoma:  "7b2ffd4b7405bdb8117cb1cb355b46e6f99a08b664d5c0c033304454f1ffbcbb"
    sha256 cellar: :any,                 sonoma:        "ec462e2093d83cda470d293078db112685752123d45c2f365283605dd5d7419b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "955b0ded5a0feb1b6419bdf3642accb7551a4b8e97eb8285632bf674b6b84712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "046c4b2eea9e84781720b18fcdec996377aeea80ffe222d1240724294da3ffe8"
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
    url "https://files.pythonhosted.org/packages/82/1b/b5578329a77fe06aa66645f3827a4f5c1291ad39925775b49343f209b5d5/awscrt-0.30.0.tar.gz"
    sha256 "e1a133430e71116e9c0f101b0d11227f47b7c561ad5303f5af00f6c33a16f382"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/e3/66/7e97aa77af7cf6afbff26e3651b564fe41932599bc2d3dce0b2f73d4829a/crc32c-2.8.tar.gz"
    sha256 "578728964e59c47c356aeeedee6220e021e124b9d3e8631d95d9a5e5f06e261c"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/73/cb/09e5184fb5fc0358d110fc3ca7f6b1d033800734d34cac10f4136cfac10e/psutil-7.2.1.tar.gz"
    sha256 "f7583aec590485b43ca601dd9cea0dcd65bd7bb21d30ef4ddbf4ea6b5ed1bdd3"
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
