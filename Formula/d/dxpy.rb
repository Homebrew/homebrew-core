class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/69/8f/2e4a39579c890fef8e92d311a87149a3eeaa9187281fb79f5a0b0ca31c12/dxpy-0.407.0.tar.gz"
  sha256 "cf90e1030e5a4868e7013fbbb28d760cdade72219e6b72319c2dcac5a9e701ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f2782d92d857cbe67bf9b213a43e80e839caccdf16c51e45dc7ea53e7df5e63"
    sha256 cellar: :any,                 arm64_sequoia: "c159447a15aed01a900e701afc426bd4fde5f2b16e37a9580dfd291572340f78"
    sha256 cellar: :any,                 arm64_sonoma:  "c86ad47f83dc60e849d46affeb2885295ab23e1d09b45eafedc3251872657186"
    sha256 cellar: :any,                 sonoma:        "66175895edcb887b339f40ff1af940c1e8fe1aed8fede8394c9bb9a02ad68f0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98bec1b338222130444ce291066625353a47757ffe154be45d86b4f46af4a035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c072158c8284f0def8592aa79eb73f4ca6b05d7ddb87bae08b14317f285279ca"
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

  conflicts_with "deno", because: "both install `dx` binaries"

  pypi_packages exclude_packages: %w[cryptography certifi]

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/3d/e7/354b811e17c0dc8641209446d39306667a34a5158fc8b2fb03333d1cb1a3/awscrt-0.31.3.tar.gz"
    sha256 "16cc0380eef073a2e37eff01a98f3f2108ead6dbb4a919d40f656db0d8ad4b71"
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
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"
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
