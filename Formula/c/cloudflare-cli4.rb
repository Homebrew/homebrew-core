class CloudflareCli4 < Formula
  include Language::Python::Virtualenv

  desc "CLI for Cloudflare API v4"
  homepage "https://github.com/cloudflare/python-cloudflare-cli4"
  url "https://github.com/cloudflare/python-cloudflare-cli4/archive/refs/tags/2.19.4.tar.gz"
  sha256 "7a3e9b71cad0a995d59b0c3e285e1cf16bd08d9998509f44d7c321abe803d22b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e214f0e5e14308f0fef6f3b141a99d5bc06f62ca1bf6446753d34125fe9a2100"
    sha256 cellar: :any,                 arm64_ventura:  "aa60dfee6b98a70ab7db2759487097cebfcc4a9e072791781458013a5543bb40"
    sha256 cellar: :any,                 arm64_monterey: "56e8085bb18dc0703fba593c6217ce943df2e5db3ead4b2c4925f1489bf5b7a5"
    sha256 cellar: :any,                 sonoma:         "89d92d7e22c43f6c47ab35c9d62bd1c5cbe69a7d72e774d3f1e8441785a41a96"
    sha256 cellar: :any,                 ventura:        "4de6caca8bb4af1c0b3943a7dd38fff6ada1f201508c7e8d06dd3ae0e172d89c"
    sha256 cellar: :any,                 monterey:       "c842588105813cb0225dedb2e241ee0ae47d31127407013c8861110b04d2388e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a972ca71c5dbd48d7c63776e040e23ac633758e4b619ec67eb75188a225c1984"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/71/da/e94e26401b62acd6d91df2b52954aceb7f561743aa5ccc32152886c76c96/certifi-2024.2.2.tar.gz"
    sha256 "0569859f95fc761b18b45ef421b1290a0f65f147e92a1e5eb3e635f9a5e4e66f"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jsonlines" do
    url "https://files.pythonhosted.org/packages/35/87/bcda8e46c88d0e34cad2f09ee2d0c7f5957bccdb9791b0b934ec84d84be4/jsonlines-4.0.0.tar.gz"
    sha256 "0c6d2c09117550c089995247f605ae4cf77dd1533041d366351f6f298822ea74"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/86/ec/535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392db/requests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".cloudflare/cloudflare.cfg").write <<~EOS
      [CloudFlare]
      email = BrewTestBot@example.com
      token = 00000000000000000000000000000000
      [Work]
      token = 00000000000000000000000000000000
    EOS

    output = shell_output("#{bin}/cli4 --profile Work /zones 2>&1", 1)
    assert_match "cli4: /zones - 6111 Invalid format for Authorization header", output
    assert_match version.to_s, shell_output("#{bin}/cli4 --version 2>&1", 1)
  end
end
