class Gloox < Formula
  desc "C++ Jabber/XMPP library that handles the low-level protocol"
  homepage "https://camaya.net/gloox/"
  url "https://camaya.net/download/gloox-1.0.24.tar.bz2"
  sha256 "ae1462be2a2eb8fe5cd054825143617c53c2c9c7195606cb5a5ba68c0f68f9c9"

  livecheck do
    url :homepage
    regex(/Latest stable version.*?href=.*?gloox[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d3a7c4aa4b061fe4dce520662e632bc9983b294cb94e479ea46221f43ea46c9f"
    sha256 cellar: :any,                 big_sur:       "143b0a77842e9df885799b07e6cfb166c7951841b8b23027db51c9b93a5ba8a7"
    sha256 cellar: :any,                 catalina:      "decf46b20a794855cf3bd3c06e05111d15fd11de4dec1c5fdf6a1253eb865e7a"
    sha256 cellar: :any,                 mojave:        "607baeeadc43775af6799d5bc4715239cbe6455ec72d2e14d82523d425fa7799"
    sha256 cellar: :any,                 high_sierra:   "011c8a88d0f8970c9ad4ed339972b55b56c26120e64ef9d1576b68c03b10f706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20accd40e451cec9b2bf58e94be2ff78af6db0d719ec905fa5e2123049e63267"
  end

  depends_on "pkg-config" => :build
  depends_on "libidn"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-zlib",
                          "--disable-debug",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"gloox-config", "--cflags", "--libs", "--version"
  end
end
