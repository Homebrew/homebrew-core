class Abi3audit < Formula
  include Language::Python::Virtualenv

  desc "Scans Python packages for abi3 violations and inconsistencies"
  homepage "https://github.com/trailofbits/abi3audit"
  url "https://files.pythonhosted.org/packages/f8/75/fb78347ed058522cd5864dfa0e049a3b83e1ca361a6ba75552141a8c76a5/abi3audit-0.0.17.tar.gz"
  sha256 "d05299c2b4ca2d4897c7ed417fc89ed9ac684cb50542e13287bb129e8499de89"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ee0e2136476e1e684b46ce25413b70b31a60906fb3766f80e29de263d2c8238"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ee0e2136476e1e684b46ce25413b70b31a60906fb3766f80e29de263d2c8238"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ee0e2136476e1e684b46ce25413b70b31a60906fb3766f80e29de263d2c8238"
    sha256 cellar: :any_skip_relocation, sonoma:        "407f11cc690a8b7507308722860a36484f6653727c54ccd19af58edb226b0ec0"
    sha256 cellar: :any_skip_relocation, ventura:       "407f11cc690a8b7507308722860a36484f6653727c54ccd19af58edb226b0ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "705101f59e30e938653304cf5e155b20a0672b846f7243b79be6072001dc1380"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "rust" => :build
  end

  resource "abi3info" do
    url "https://files.pythonhosted.org/packages/3c/4f/55f878633f05a93fedf25b89b109ee70764ebdd785d02be12b284425c0a4/abi3info-2024.10.8.tar.gz"
    sha256 "f81f9513cba039a5231d6523ca58b071d1d96afe430cd576bfda3e73c8b4e55f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/64/65/af6d57da2cb32c076319b7489ae0958f746949d407109e3ccf4d115f147c/cattrs-24.1.2.tar.gz"
    sha256 "8028cfe1ff5382df59dd36474a86e02d817b06eaf8af84555441bac915d2ef85"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b0/ee/9b19140fe824b367c04c5e1b369942dd754c4c5462d5674002f75c4dedc1/certifi-2024.8.30.tar.gz"
    sha256 "bec941d2aa8195e248a60b31ff9f0558284cf01a52591ceda73ea9afffd69fd9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "kaitaistruct" do
    url "https://files.pythonhosted.org/packages/54/04/dd60b9cb65d580ef6cb6eaee975ad1bdd22d46a3f51b07a1e0606710ea88/kaitaistruct-0.10.tar.gz"
    sha256 "a044dee29173d6afbacf27bcac39daf89b654dd418cfa009ab82d9178a9ae52a"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pefile" do
    url "https://files.pythonhosted.org/packages/03/4f/2750f7f6f025a1507cd3b7218691671eecfd0bbebebe8b39aa0fe1d360b8/pefile-2024.8.26.tar.gz"
    sha256 "3ff6c5d8b43e8c37bb6e6dd5085658d658a7a0bdcd20b6a07b1fcfc1c4e9d632"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/88/56/0f2d69ed9a0060da009f672ddec8a71c041d098a66f6b1d80264bf6bbdc0/pyelftools-0.31.tar.gz"
    sha256 "c774416b10310156879443b81187d182d8d9ee499660380e645918b50bc88f99"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/1a/be/7b2a95a9e7a7c3e774e43d067c51244e61dea8b120ae2deff7089a93fb2b/requests_cache-1.2.1.tar.gz"
    sha256 "68abc986fdc5b8d0911318fbb5f7c80eebcd4d01bfacc6685ecf8876052511d1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/92/76/40f084cb7db51c9d1fa29a7120717892aeda9a7711f6225692c957a93535/rich-13.8.1.tar.gz"
    sha256 "8260cda28e3db6bf04d2d1ef4dbc03ba80a824c88b0e7668a0f23126a424844a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "url-normalize" do
    url "https://files.pythonhosted.org/packages/ec/ea/780a38c99fef750897158c0afb83b979def3b379aaac28b31538d24c4e8f/url-normalize-1.4.3.tar.gz"
    sha256 "d23d3a070ac52a67b83a1c59a0e68f8608d1cd538783b401bc9de2c0fac999b2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/abi3audit sip 2>&1", 1)
    assert_match(/sip: \d+ extensions scanned; \d+ ABI version mismatches and \d+ ABI\s+violations found/, output)
  end
end
