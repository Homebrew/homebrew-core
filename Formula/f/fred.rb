class Fred < Formula
  include Language::Python::Virtualenv

  desc "Fully featured FRED Command-line Interface & Python API wrapper"
  homepage "https://fred.stlouisfed.org/docs/api/fred/"
  url "https://files.pythonhosted.org/packages/ff/22/44051587a95461a3fb0cd57e5ba215f3c4d3086544294e5ac79ab0028c20/fred_py_api-1.2.0.tar.gz"
  sha256 "4e588b6f5349461436aad2fc20ff4ca97b3b69fb0daa24c0e12ab837dedad90f"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0beb0ec68875985b1f768c52e14e2395c6c8f298917bede7de809c4a5372d3ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0beb0ec68875985b1f768c52e14e2395c6c8f298917bede7de809c4a5372d3ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0beb0ec68875985b1f768c52e14e2395c6c8f298917bede7de809c4a5372d3ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "32e3387f6cd6eaa54170e7c708e5dfda68f0202cc8e467610535b053d20f6a5e"
    sha256 cellar: :any_skip_relocation, ventura:        "32e3387f6cd6eaa54170e7c708e5dfda68f0202cc8e467610535b053d20f6a5e"
    sha256 cellar: :any_skip_relocation, monterey:       "32e3387f6cd6eaa54170e7c708e5dfda68f0202cc8e467610535b053d20f6a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22a5d305072c2bce7202a0135b3286ea35e61da387254a3e5009ae48bc2463bf"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/c2/02/a95f2b11e207f68bc64d7aae9666fed2e2b3f307748d5123dffb72a1bbea/certifi-2024.7.4.tar.gz"
    sha256 "5a1e7645bc0ec61a09e26c36f6106dd4cf40c6db3a1fb6352b0244e7fb057c7b"
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
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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
