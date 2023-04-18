class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/39/d7/ab05ae34dd57dd657e492d95ce7ec6bfebfb3bfcdc7316660ac5a13fcfee/fonttools-4.39.3.zip"
  sha256 "9234b9f57b74e31b192c3fc32ef1a40750a8fbc1cd9837a7b7bfc4ca4a5c51d7"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "126a1f7b209d33b376eeecdf3652eac7bd4cd025b31d1ef5214d20a5905173f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3090e113d33e59d24def55d5b6e866e3f7c29743e4238684882d0d11c84e13d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4903adb26d76e0e79c5d0274628be83b355e4768ab37d2da8d3f68c5bba47d4c"
    sha256 cellar: :any_skip_relocation, ventura:        "54b9e5dc40720de0aa4f931cb5e6d2ffaf043d644b09fca59330f891e2d0602a"
    sha256 cellar: :any_skip_relocation, monterey:       "3aa7f9a3ef22343a96fae40d13a63aac5e215dd1851c190259bfc0e62bc9ada8"
    sha256 cellar: :any_skip_relocation, big_sur:        "2acd69cfe6b2e03da5944c562bdc7089cc3e3f41bdeb3154f96adbfed6691f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57e6763fdc511ad7f1144c23c42a03fe1a44b143657460baceade9a1b93d56d2"
  end

  depends_on "python@3.11"

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
