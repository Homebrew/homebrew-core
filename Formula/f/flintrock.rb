class Flintrock < Formula
  include Language::Python::Virtualenv

  desc "Tool for launching Apache Spark clusters"
  homepage "https://github.com/nchammas/flintrock"
  url "https://files.pythonhosted.org/packages/e9/3b/810c7757f6abb0a73a50c2da6da2dacb5af85a04b056aef81323b2b6a082/Flintrock-2.1.0.tar.gz"
  sha256 "dde4032630ad44c374c2a9b12f0d97db87fa5117995f1c7dd0f70b631f47a035"
  license "Apache-2.0"

  bottle do
    rebuild 6
    sha256 cellar: :any,                 arm64_tahoe:   "3f62ae6a65feab73644226a481a28b155dc5a2d607139ec4233dc7f9fc4e757e"
    sha256 cellar: :any,                 arm64_sequoia: "127432ae39c73662b25044a21d91e22fdf3e9af06b76d735474d01c84348b0d6"
    sha256 cellar: :any,                 arm64_sonoma:  "5c80b77f50eb1c6d43b55ff1112b2d3a0173a584da9f74b5498d3803a689f2f6"
    sha256 cellar: :any,                 sonoma:        "1d7f089c52d88f351ccbc0eea15ba834ccfcfbd597191480be7cbc58af84dceb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e63dbb5e0d087eccc75f15c30ded821018dfc034597ed56cff8218342221cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff3f69ebe041c56f33fd019cbcb28e58220571692d2d487c6078a2e285b71449"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "python@3.14"

  # `pyyaml` is manually updated to support Python 3.14
  # Issue ref: https://github.com/nchammas/flintrock/issues/385

  pypi_packages exclude_packages: "cryptography"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/8d/5f/4ee13ee77641c98032fcddb51456a26976f69365fdc3c6c9e699970b9e99/boto3-1.29.4.tar.gz"
    sha256 "ca9b04fc2c75990c2be84c43b9d6edecce828960fc27e07ab29036587a1ca635"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/10/6f/e7fe287501ae0bb2732e0752dde93c4a2ad1922953be16dd912acc2c26be/botocore-1.32.4.tar.gz"
    sha256 "6bfa75e28c9ad0321cefefa51b00ff233b16b2416f8b95229796263edba45a39"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/44/03/158ae1dcb950bd96f04038502238159e116fafb27addf5df1ba35068f2d6/paramiko-3.3.1.tar.gz"
    sha256 "6a3777a961ac86dbef375c5f5b8d50014a1a96d0fd7f054a43bc880134b0ff77"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/06/c6/a3124dee667a423f2c637cfd262a54d67d8ccf3e160f3c50f622a85b7723/pynacl-1.6.0.tar.gz"
    sha256 "cb36deafe6e2bce3b286e5d1f3e1c246e0ccdb8808ddb4550bb2792f2df298f2"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"flintrock", shell_parameter_format: :click)
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"flintrock"
    msg = shell_output("#{bin}/flintrock destroy fascism 2>&1", 1)
    assert_match "could not find your AWS credentials", msg
  end
end
