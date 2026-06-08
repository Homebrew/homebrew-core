class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/54/a3/fcbc64c5e038b87394e72a03131643109e451a697d467a7f90c6b6413ee9/awscurl-0.42.tar.gz"
  sha256 "c19d05427a104c11f0080d74063e607e438fb3eaf789150c84bf6b28639f6937"
  license "MIT"
  revision 2
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d449ccb76c4f4c740bc82be6554a03d1e97660c3021f79ba04e498e3d2e224d4"
    sha256 cellar: :any,                 arm64_sequoia: "f2dc0582369e5689182348ba63217ec5168ca9867955d0314ed6ef3fff00561b"
    sha256 cellar: :any,                 arm64_sonoma:  "348ba2c42beb449fc2efa6b22a63a4904f26dfca717411fbc37d7ec04fb4098a"
    sha256 cellar: :any,                 sonoma:        "1f66c60224f1a617eade035c67a0f105eda0e21bbe6a764de34905001eaa3755"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b7c05688b0f6c10d7f8f8b13d1e8a0955cbec17885401f59fc607c63f41fb6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb20086fe15c25d5af20a3073212e05794746ca3e84a65e6dd2935d165222b92"
  end

  depends_on "cmake" => :build # for `awscrt`
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
  depends_on "openssl@3" # for `awscrt`
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: ["certifi", "cryptography"]

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/92/cb/980fe60c4209af71d036276217f8b9f372f958e290c15d2849a3de4dcd23/awscrt-0.32.2.tar.gz"
    sha256 "a4f48805e8a66237923f03b7b692d213994cff42d1ff08125d1d60c74fcaf872"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ff/27/ae1a71e945ce7bde39b0677b252fe7d8a0ad7fa3d6b724d78b81469c08fe/boto3-1.43.10.tar.gz"
    sha256 "27342e5d5f6170fcc8d1e21cdd939af2448d58ac56b08d494250eaad998e30c7"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/e2/4e/c127dd0628c551f10cb890e279a9c0e367523b880c4cd3e81a1e76886174/botocore-1.43.10.tar.gz"
    sha256 "2f4af585b41dbccdfc9f49677d7bd72d713a12ef89a1dc9c8538a927649498bf"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/3f/0b/30328302903c55218ffc5199646d0e9d28348ff26c02ba77b2ffc58d294a/configargparse-1.7.5.tar.gz"
    sha256 "e3f9a7bb6be34d66b2e3c4a2f58e3045f8dfae47b0dc039f87bcfaa0f193fb0f"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/8b/ac/ea19242153b5e8be412a726a70e82c7b5c1537c83f61b20995b2eda3dcd7/configparser-7.2.0.tar.gz"
    sha256 "b629cc8ae916e3afbd36d1b3d093f34193d851e11998920fdcfc4552218b7b70"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/9b/ec/7c692cde9125b77e84b307354d4fb705f98b8ccad59a036d5957ca75bfc3/s3transfer-0.17.0.tar.gz"
    sha256 "9edeb6d1c3c2f89d6050348548834ad8289610d886e5bf7b7207728bd43ce33a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBCRYPTO"] = "1"
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBS"] = "1"

    virtualenv_install_with_resources
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    assert_match "Curl", shell_output("#{bin}/awscurl --help")

    assert_match "The AWS Access Key Id you provided does not exist in our records.",
      shell_output("#{bin}/awscurl --service s3 https://homebrew-test-non-existent-bucket.s3.amazonaws.com")
  end
end
