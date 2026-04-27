class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/54/a3/fcbc64c5e038b87394e72a03131643109e451a697d467a7f90c6b6413ee9/awscurl-0.42.tar.gz"
  sha256 "c19d05427a104c11f0080d74063e607e438fb3eaf789150c84bf6b28639f6937"
  license "MIT"
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "26033cf08b0ff62c8059fd8629c75f1a67cd7ed76bae9ddd2f291842b6296246"
    sha256 cellar: :any,                 arm64_sequoia: "30ec0625abeec8ae1b799ea475949d9779f09a89455d51d567b976f311c491eb"
    sha256 cellar: :any,                 arm64_sonoma:  "00eb0ce6b2b08a3e7bd1ef30857f75fddd6a6305a6cace23485afcba32a8e343"
    sha256 cellar: :any,                 sonoma:        "79380b8a7eefa52942e4ac2afca9e5bdf4ae9690aead96695963eb341f2cb32e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54a80ebce549e36a6c3a5d02bdeb8931c8e4d5e4dcd08fabbd101a1f76cd3bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a45899d8fb9fc3b53043c237c54d00d18a83beb830833bf2d084a12f7f504a"
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
    url "https://files.pythonhosted.org/packages/fd/98/ddd893b872519da47573810aac0b225433c2a4162967df73bfe0bd282bbe/awscrt-0.32.1.tar.gz"
    sha256 "1faccfaf365c7ae8975307e42edec44eb3ae3feba2805aff2979ba8474b6bb4f"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/dd/ac/e6b2b24d53c830500176f710594efcde626186b5b3c9aead6f8837976956/boto3-1.42.93.tar.gz"
    sha256 "ff81c6bac708cb95c4f8b27e331ac67d95c6908dd86bcb7b15b8941960f2bc4c"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/1b/d4/eb53f7ed81836696abf7103c9c901a0cace9217328094ca93419016a78c9/botocore-1.42.93.tar.gz"
    sha256 "9ce49863c50b43f7942edd295fb16bfc6d227264ce6fc32c8f2426ef11b9351b"
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
    url "https://files.pythonhosted.org/packages/22/12/2948fbe5513d062169bd91f7d7b1cd97bc8894f32946b71fa39f6e63ca0c/idna-3.12.tar.gz"
    sha256 "724e9952cc9e2bd7550ea784adb098d837ab5267ef67a1ab9cf7846bdbdd8254"
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
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
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
