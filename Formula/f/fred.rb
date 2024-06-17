class Fred < Formula
  include Language::Python::Virtualenv

  desc "Fully featured FRED Command-line Interface & Python API wrapper"
  homepage "https://fred.stlouisfed.org/docs/api/fred/"
  url "https://files.pythonhosted.org/packages/c8/c8/eec6f19c93f33a5bfbe1f5fe8f757acaa440fdb56f4209f13ef7896ea1f1/fred-py-api-1.1.3.tar.gz"
  sha256 "792760b47976f15b0e11c49944de456623e48ec67c791e03770cddca22e859f4"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "675320e55680b33458c48d949c6c20dabaeff937064d30a06a9f1e8c941d20d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90fb0f2491070fb44861fe53836f5ae688a81611c6f498f3d4d3b579a07d4f21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3efdb1b83a8ea7466e3639bc693f550917bdf32c0a6db8448f6e15cb382bc469"
    sha256 cellar: :any_skip_relocation, sonoma:         "127463b053ffa4cb29b24deaeeb6368aad24d31799732f40b48e2dae32fb7eac"
    sha256 cellar: :any_skip_relocation, ventura:        "75b6c69e4ca1ae322f0feeabee6b0571e09dad6c2e7a306e29599f4e83704463"
    sha256 cellar: :any_skip_relocation, monterey:       "778a773dacf5f16d1c7ff77aee9c4e80da4ead54a6fc7a8ce742cc9cca85d5ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "073f4405c4cc293a456c0eec8a91bd26d67615b297f21d0a54633ed1861c1601"
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
    url "https://files.pythonhosted.org/packages/d8/c1/f32fb7c02e7620928ef14756ff4840cae3b8ef1d62f7e596bc5413300a16/requests-2.32.1.tar.gz"
    sha256 "eb97e87e64c79e64e5b8ac75cee9dd1f97f49e289b083ee6be96268930725685"
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
