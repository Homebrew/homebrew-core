class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://awsu.me"
  url "https://files.pythonhosted.org/packages/be/88/1e48b765afdaedb1f7b5d5e51a009f12e5b0f32b7e7f2ed4c5bd774387f6/awsume-4.5.0.tar.gz"
  sha256 "46f64695c5b9649058669353cfcd56b90538d65d06995dbbe9a13d3f992206c6"
  license "MIT"
  head "https://github.com/trek10inc/awsume.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fa6d4309582c604ce00ba83e7e6b2f15d8dc91b280bc85ee235d7912e62b50fa" => :big_sur
    sha256 "0060e3d76e2fabfdd8a037ff258d95c4df87cc297c180c45fe724fda1a470f5b" => :arm64_big_sur
    sha256 "d40f48b8b4c7f3ed85cb5ce655946e3e8968ad785dccba47ba60e35745fc9a57" => :catalina
    sha256 "c9c8f5a9a027e89eb52ca3c081a5f7afb86e464946f9a1f8c289cc054f9d60e8" => :mojave
  end

  depends_on "openssl@1.1"
  depends_on "python@3.9"
  uses_from_macos "sqlite"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/b5/53/7942c6a3242880c3632fa5e1a7de121e3724ae7d39a0f23c42c40f754bdc/boto3-1.16.22.tar.gz"
    sha256 "066b9dfd466e42c206dbbd282da030a6d5cade4ef7e9f1c90a79ebde1310b217"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/ed/8e/a9c61e87ed728d336086996b3d6df175514d0b06273ac41b23637aeef0c9/botocore-1.19.22.tar.gz"
    sha256 "87d77925ea8d35898ff1627f6f97d396bed44d37fff960daae181a76ba413546"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/33/e0/82d459af36bda999f82c7ea86c67610591cf5556168f48fd6509e5fa154d/psutil-5.7.3.tar.gz"
    sha256 "af73f7bcebdc538eda9cc81d19db1db7bf26f103f91081d780bbacfcb620dee2"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/50/de/2b688c062107942486c81a739383b1432a72717d9a85a6a1a692f003c70c/s3transfer-0.3.3.tar.gz"
    sha256 "921a37e2aefc64145e7b73d50c71bb4f26f46e4c9f414dc648c6245ff92cf7db"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/29/e6/d1a1d78c439cad688757b70f26c50a53332167c364edb0134cadd280e234/urllib3-1.26.2.tar.gz"
    sha256 "19188f96923873c92ccb987120ec4acaa12f0461fa9ce5d3d0772bc965a39e08"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awsume -v 2>&1")

    file_path = File.expand_path("~/.awsume/config.yaml")
    shell_output(File.exist?(file_path))

    assert_match "PROFILE  TYPE  SOURCE  MFA?  REGION  ACCOUNT", shell_output("#{bin}/awsume --list-profiles 2>&1")
  end
end
