class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/06/7a/83dd380d74b56a57c3eafce90265035d8727469d05ca4d2942d14367a6c7/fonttools-4.69.1.tar.gz"
  sha256 "d09a2ea8ed4c71ac52e789ba9313da3e26cee3f812400d7e8a8b3a38d0f98dfe"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    manifest_sha256 "6ddbe01fed1c0dbac14723a8ccd928a5abb4a746a28c378690351f7016c1d3e1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "40416ec5a9685137b460bf41f3e85b1d620530dd9e6483bd15fdf1d885ec7396"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f465a1ab6fd74e9592de39158112ae782d953295e597cf359d816caa310662ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36b90fc365b79d50a8dcf18732fb132dc15b112771697cdcf2f466e19a357c85"
    sha256 cellar: :any,                 arm64_linux:       "8e7c408c17ecd3e806e8805236bfea7f5c8b100882d8101335ea3c881a2fc2bb"
    sha256 cellar: :any,                 x86_64_linux:      "454a17e629f68464155b7bde0c85dcebd935c9431fc0be76477e996e3da43ad7"
  end

  depends_on "python@3.15"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages package_name: "fonttools[lxml,woff]"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/cf/81/1546c983678a9b4e77cb4718eaedd1b2caf24a6cdbf1eb8775938d22aff7/brotli-1.2.1.tar.gz"
    sha256 "02b2f7b5a83485efe448a44ddf7983def05c3bb1dcf917d4f7154070260e13de"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/74/21/3b6af43a663b22b00e738bb0642931a2579e15da6852613d56c6aa535d28/zopfli-0.4.3.tar.gz"
    sha256 "d3a50f91a13cea9bafe025de8fd87a005eb26de02a4f0c193127ddbf23ac8ebe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.ttx"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.woff2"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
