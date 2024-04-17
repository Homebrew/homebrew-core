class Fred < Formula
  include Language::Python::Virtualenv

  desc "Fully featured FRED Command-line Interface & Python API wrapper"
  homepage "https://fred.stlouisfed.org/docs/api/fred/"
  url "https://files.pythonhosted.org/packages/c8/c8/eec6f19c93f33a5bfbe1f5fe8f757acaa440fdb56f4209f13ef7896ea1f1/fred-py-api-1.1.3.tar.gz"
  sha256 "792760b47976f15b0e11c49944de456623e48ec67c791e03770cddca22e859f4"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d5693aeeda98463ac97de506a05f39a94d6dc9868ede3ac75a2f2bf74a584e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d5693aeeda98463ac97de506a05f39a94d6dc9868ede3ac75a2f2bf74a584e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d5693aeeda98463ac97de506a05f39a94d6dc9868ede3ac75a2f2bf74a584e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "cda0d245c7774f5d667aa031b6b5eea5cbee44e41585fb00282afd02bf66df18"
    sha256 cellar: :any_skip_relocation, ventura:        "cda0d245c7774f5d667aa031b6b5eea5cbee44e41585fb00282afd02bf66df18"
    sha256 cellar: :any_skip_relocation, monterey:       "cda0d245c7774f5d667aa031b6b5eea5cbee44e41585fb00282afd02bf66df18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2272cea9afc775e00235900908ae33778dfe5e784bdd3219d157c77d4c664b2e"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/71/da/e94e26401b62acd6d91df2b52954aceb7f561743aa5ccc32152886c76c96/certifi-2024.2.2.tar.gz"
    sha256 "0569859f95fc761b18b45ef421b1290a0f65f147e92a1e5eb3e635f9a5e4e66f"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # assert output & ensure exit code is 2
    # NOTE: this makes an API request to FRED with a purposely invalid API key
    invalid_api_key = "sqwer1234asdfasdfqwer1234asdfsdf"
    output = shell_output("#{bin}/fred --api-key #{invalid_api_key} categories get-category -i 15 2>&1", 2)
    assert_match "Bad Request.  The value for variable api_key is not registered.", output
  end
end
