class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/9c/82/33679049696e05fc85596ff93f19fa0b9f73200de62d5ab0bfd4eed9aa9f/awscurl-0.24.tar.gz"
  sha256 "6a8eab18238f41297b9f568fead3161e898fb0f68f2b1bb3ed5ece358a929206"
  license "MIT"
  revision 1
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f13f65e5c449e9b4ed760b262914baa5819623357b7d0131569bb3108f1113d6"
    sha256 cellar: :any,                 arm64_big_sur:  "5b4786b55be116cfa551e77bc3d06752f3e2d3cf9d30a4acf979f864e733f131"
    sha256 cellar: :any,                 monterey:       "e4ebebdc1423851f2e729afda151d05097f09fa28a6f5bc455634b14ef233a7c"
    sha256 cellar: :any,                 big_sur:        "63474937363760c00fcdf13adfd424536b23457d2173a3ee9d3ab59d0f765009"
    sha256 cellar: :any,                 catalina:       "9f2fa777da553e8016a94009beeae8e38282c3514d716d289953aa2bb54d9673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fce31b14f641d984c8cc28864849404615bac86ea7a0bd50381dc07c09abd7f7"
  end

  depends_on "rust" => :build
  depends_on "python@3.9"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2e/92/87bb61538d7e60da8a7ec247dc048f7671afe17016cd0008b3b710012804/cffi-1.14.6.tar.gz"
    sha256 "c9a875ce9d7fe32887784274dd533c57909b7b1dcadcc128a2ac21331a9765dd"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/4e/2af0238001648ded297fb54ceb425ca26faa15b341b4fac5371d3938666e/charset-normalizer-2.0.4.tar.gz"
    sha256 "f23667ebe1084be45f6ae0538e4a5a865206544097e4e8bbcacf42cd02a348f3"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/d9/ad/d82750ad3a9e3419425eeeef7fbb5c8381dc8ec64a9894ddc3854837b10f/ConfigArgParse-1.5.1.tar.gz"
    sha256 "371f46577e76ec71a183b88378f36dd09f4b946f60fe60712f411b020f26b812"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/c9/9c/c1ac39b3c72a70e93479cb4b7f1123f693293c5e4c40fdb3e1242f740665/configparser-5.0.2.tar.gz"
    sha256 "85d5de102cfe6d14a5172676f09d19c465ce63d6019cf0a4ef13385fc535e828"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9b/77/461087a514d2e8ece1c975d8216bc03f7048e6090c5166bc34115afdaa53/cryptography-3.4.7.tar.gz"
    sha256 "3d10de8116d25649631977cb37da6cbdd2d6fa0e0281d014a5b7d337255ca713"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/98/cd/cbc9c152daba9b5de6094a185c66f1c6eb91c507f378bb7cad83d623ea88/pyOpenSSL-20.0.1.tar.gz"
    sha256 "4c231c759543ba02560fcd2480c48dcec4dae34c9da7d3747c508227e0624b51"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Curl", shell_output("#{bin}/awscurl --help")

    assert_match "No access key is available",
      shell_output("#{bin}/awscurl --service s3 https://homebrew-test-none-existant-bucket.s3.amazonaws.com 2>&1", 1)
  end
end
