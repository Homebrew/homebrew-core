class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/c8/77/7da6af880d56aed4a4023bb7c725e15c72a3088afd729ffd373eed0f5a18/awscurl-0.44.tar.gz"
  sha256 "13056e867ac33f556f29d3662102bfc3c40259ea037c6d817c5914dbb2bbd948"
  license "MIT"
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3a01db02b1d5817a61f748689526453a1e1d2169fc0ccd746076cdef8a92fc4a"
    sha256 cellar: :any, arm64_sequoia: "6b745b6f5eaebf72915629aa572ccfc3e5d2be8a5a1aaa9a2cf7d4691ad23d01"
    sha256 cellar: :any, arm64_sonoma:  "f13feb196ff712eceb8622dac1e24833bbe3ff2fca361e9ae487d85da0c6a450"
    sha256 cellar: :any, sonoma:        "f98b3c1038167358c1b93a16fd6c09e82980f6f7d49dd8be2d0d895987764e8c"
    sha256 cellar: :any, arm64_linux:   "f2eeabf5498099b8f4c37412bbb4d1e61d2d20c306b500d100e957faa04ce6d4"
    sha256 cellar: :any, x86_64_linux:  "43500b061cca631609e815b407f8b61e84de340bbb265d26d31ed6a78665fad8"
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

  on_macos do
    depends_on "s2n"
  end

  pypi_packages exclude_packages: ["certifi", "cryptography"]

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/ce/33/ed6d3c91d7b136a91eeea3bea1023e818f5f99d4fcbd8956c645a2dc6006/awscrt-0.34.1.tar.gz"
    sha256 "a3ae8e35c3a3eefdb2a15859887a05b926d0456d21ccba1b49861cfe46bcc8c2"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/85/a6/9c02ff00d08ea87908934351d244e35bb6fb5cbc169e1a14fc5bd80d124b/boto3-1.43.29.tar.gz"
    sha256 "354006c512cdb87ef8214a095f2ade961c8145734475cd7a7e6b39260ff5494a"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/6f/54/df99c5ca5c9ef275e34b87e177782e3ca054fc35f1f462c40fe180936c81/botocore-1.43.29.tar.gz"
    sha256 "dce39d33b707aa162aa3820975f99d7f8f746d46576169fb42ce4f2b3b56b261"
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
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
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
    url "https://files.pythonhosted.org/packages/e0/1f/12417f7f493fc45e1f9fd5d4a9b6c125cf8d2cf3f8ddbdfab3e76406e9d6/s3transfer-0.18.0.tar.gz"
    sha256 "3760b8b7ec1315da54048b2d626276732bee4300d054d492d4e1d43e20d4ecbd"
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
