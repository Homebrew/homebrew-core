class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/0c/b5/672312ae80ce8b8eb9779c56052a24c8f36652aa7293a1a420553bcf03e5/fonttools-4.68.0.tar.gz"
  sha256 "73294e233070f71e2b3653b6bd8564af676d57f26d075761fb06d1ab2e4a7a5d"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "90adf249d853cb752f0dc594586c6ecc4a2488869f20c0682bb197947d04bb30"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "650cfe269249c05a500f1c16ef9b8dc01c2895291bae0d17075b96fdab8d55e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0fea285c9fb3d319671a1d636f48759a826b23b6b77befcde1b6217df7d42a20"
    sha256 cellar: :any,                 arm64_linux:       "40bf2c27fa0edf420a211bf728a575d6cbf7952b7f5a3f7815b0eb313bcf0870"
    sha256 cellar: :any,                 x86_64_linux:      "6885f05e0c1b34446cd654f2e6bb6c9aa0deb045be43b0af6d691746e8dcda5e"
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
