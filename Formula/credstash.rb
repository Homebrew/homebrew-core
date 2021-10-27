class Credstash < Formula
  include Language::Python::Virtualenv

  desc "Little utility for managing credentials in the cloud"
  homepage "https://github.com/fugue/credstash"
  url "https://files.pythonhosted.org/packages/b4/89/f929fda5fec87046873be2420a4c0cb40a82ab5e30c6d9cb22ddec41450b/credstash-1.17.1.tar.gz"
  sha256 "6c04e8734ef556ab459018da142dd0b244093ef176b3be5583e582e9a797a120"
  license "Apache-2.0"
  revision 4
  head "https://github.com/fugue/credstash.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "20933684d1f4dc523373179f028cedf246bc1c38be113083fa56c29c780c39ab"
    sha256 cellar: :any,                 arm64_big_sur:  "eb3d91bb0acbb86f65f9ab7b4a92de6dcc56f50af3d0d63899d0a17d420eed80"
    sha256 cellar: :any,                 monterey:       "d26a6f3883011511a2052e7abbe6b1f35bd21e2a68baca5e5afa6750db2f44ca"
    sha256 cellar: :any,                 big_sur:        "17bbec854f6bb5728c0300213f1cde490b641d83d49ede0900215c76905a344a"
    sha256 cellar: :any,                 catalina:       "56fb65066289625637f728e37762e9ed12366d6bb3574c6ec51e079e3e8b1582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a82749afb4c1fbcd2210f868054b58aeb9f07736f535b9ffa7345d61eae3203"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/e4/c3/ea17ed52138ba29aa6cdddec791fcf8865d54c26c74444a60929247069e5/boto3-1.17.24.tar.gz"
    sha256 "bf4a321da7dbe0c5a20380ff9f6a8a4e2e135e72a40348890122a197368b4421"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/5a/19/d40be5a0a2484744deedc796fbf61996a55e248ed4f89916c6900350a456/botocore-1.20.24.tar.gz"
    sha256 "9398bcd9491442aa559a7c111b96004bb06af612e53baa7165b0a646bb43534d"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/fa/2d/2154d8cb773064570f48ec0b60258a4522490fcb115a6c7c9423482ca993/cryptography-3.4.6.tar.gz"
    sha256 "2d32223e5b0ee02943f32b19245b61a62db83a882f0e76cc564e1cec60d48f87"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/08/e1/3ee2096ebaeeb8c186d20ed16c8faf4a503913e5c9a0e14cd6b8ffc405a3/s3transfer-0.3.4.tar.gz"
    sha256 "7fdddb4f22275cf1d32129e21f056337fd2a80b6ccef1664528145b72c49e6d2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d7/8d/7ee68c6b48e1ec8d41198f694ecdc15f7596356f2ff8e6b1420300cf5db3/urllib3-1.26.3.tar.gz"
    sha256 "de3eedaad74a2683334e282005cd8d7f22f4d55fa690a2a1020a416cb0a47e73"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    output = shell_output("#{bin}/credstash put test test 2>&1", 1)
    assert_match "Could not generate key using KMS key", output
  end
end
