class Fred < Formula
  include Language::Python::Virtualenv

  desc "Fully featured FRED Command-line Interface & Python API wrapper"
  homepage "https://fred.stlouisfed.org/docs/api/fred/"
  url "https://files.pythonhosted.org/packages/ff/22/44051587a95461a3fb0cd57e5ba215f3c4d3086544294e5ac79ab0028c20/fred_py_api-1.2.0.tar.gz"
  sha256 "4e588b6f5349461436aad2fc20ff4ca97b3b69fb0daa24c0e12ab837dedad90f"
  license "MIT"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf7e2ff3527b70acf8ae9d3880f9f7272623f831e25453efee8100e4a6beeef5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf7e2ff3527b70acf8ae9d3880f9f7272623f831e25453efee8100e4a6beeef5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf7e2ff3527b70acf8ae9d3880f9f7272623f831e25453efee8100e4a6beeef5"
    sha256 cellar: :any_skip_relocation, sequoia:       "b3be8042d767192bc4dcfc57dd74458506c4d0f8e2b6771eb11dec225893848b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3be8042d767192bc4dcfc57dd74458506c4d0f8e2b6771eb11dec225893848b"
    sha256 cellar: :any_skip_relocation, ventura:       "b3be8042d767192bc4dcfc57dd74458506c4d0f8e2b6771eb11dec225893848b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf7e2ff3527b70acf8ae9d3880f9f7272623f831e25453efee8100e4a6beeef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf7e2ff3527b70acf8ae9d3880f9f7272623f831e25453efee8100e4a6beeef5"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/73/f7/f14b46d4bcd21092d7d3ccef689615220d8a08fb25e564b65d20738e672e/certifi-2025.6.15.tar.gz"
    sha256 "d747aa5a8b9bbbb1bb8c22bb13e22bd1f18e9796defa16bab421f7f7a317323b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"fred", shells: [:bash, :fish, :zsh], shell_parameter_format: :click)
  end

  test do
    # assert output & ensure exit code is 2
    # NOTE: this makes an API request to FRED with a purposely invalid API key
    invalid_api_key = "sqwer1234asdfasdfqwer1234asdfsdf"
    output = shell_output("#{bin}/fred --api-key #{invalid_api_key} categories get-category -i 15 2>&1", 2)
    assert_match "Bad Request.  The value for variable api_key is not registered.", output
  end
end
