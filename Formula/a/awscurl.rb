class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/f2/95/4e08527b8bf4b41ca2c738efc3343ef9e437106527dcf5a57591189a218c/awscurl-0.39.tar.gz"
  sha256 "709b6b6449ea54004588994f04d8ddff282ec71411a9edaf9150a765a183bbc3"
  license "MIT"
  revision 1
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a55dccc8b50b28557f4e1e1adc65a6b17cc9e7b50be5a2d809afbb1b06615107"
    sha256 cellar: :any,                 arm64_sequoia: "d6660bd718033678ca4abd40c50689ae2f977a8d364f0a0734b4a52c8e23a6ef"
    sha256 cellar: :any,                 arm64_sonoma:  "38d9d0d02a74b4d24d582742dad59e1d29ca8dfcfe01ed67ffc770ad77d885a6"
    sha256 cellar: :any,                 sonoma:        "4f1d13fb503aabe0d5d9e21ac79f357ab7cd6b437cfb53d20bf444dd28aa549e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b9af9aa524199cc5c60960ed772dd1406ea9b0ad377846d17ba756b8865d948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2e8eb9954e34829b4f887504f4fad03aaae8e560803f7b61216442028cfac39"
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
    url "https://files.pythonhosted.org/packages/3d/e7/354b811e17c0dc8641209446d39306667a34a5158fc8b2fb03333d1cb1a3/awscrt-0.31.3.tar.gz"
    sha256 "16cc0380eef073a2e37eff01a98f3f2108ead6dbb4a919d40f656db0d8ad4b71"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f1/13/33c8b8704d677fcaf5555ba8c6cc39468fc7b9a0c6b6c496e008cd5557fc/boto3-1.42.76.tar.gz"
    sha256 "aa2b1973eee8973a9475d24bb579b1dee7176595338d4e4f7880b5c6189b8814"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/70/62/a982acb81c5e0312f90f841b790abad65622c08aad356eed7008ea3d475b/botocore-1.42.76.tar.gz"
    sha256 "c553fa0ae29e36a5c407f74da78b78404b81b74b15fb62bf640a3cd9385f0874"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
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
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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
    url "https://files.pythonhosted.org/packages/34/64/8860370b167a9721e8956ae116825caff829224fbca0ca6e7bf8ddef8430/requests-2.33.0.tar.gz"
    sha256 "c7ebc5e8b0f21837386ad0e1c8fe8b829fa5f544d8df3b2253bff14ef29d7652"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
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
