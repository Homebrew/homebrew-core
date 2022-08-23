class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/60/96/9a02ef19c8670150fc2d7c373df78e2b3f69439997fd0d45b786e3527097/fonttools-4.37.0.zip"
  sha256 "2ee4509aeba40542a6c6d00895a0c66f3cb8b9edda2fa58438dd9f769e3ce76e"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a234e1cf0a724619c534b7c5b684bf51212042b0329dd52405905265715cbda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47de2376c5acb0e32ce6a24c44c49270ab40b62be683fe453ba67ee8b19acf5b"
    sha256 cellar: :any_skip_relocation, monterey:       "9cea1a1e552588a517c90b5f173e6c73d827db8bcd071b03436adb1c16dd4175"
    sha256 cellar: :any_skip_relocation, big_sur:        "608c5178e85a9dcbcc551a212357785cc111c726db5ce9732e75a0c0f39a8d80"
    sha256 cellar: :any_skip_relocation, catalina:       "09b2eca277b1e15965a8b247a242351b5450b2a6fe32d4138f69e9452dfddcdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85511781fc378c415cd967bd1e574bb6d324fe7e8c1a2fefe04c3060a3c0efc4"
  end

  depends_on "python@3.10"

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
