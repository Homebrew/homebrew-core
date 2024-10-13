class Pdf2svg < Formula
  desc "PDF converter to SVG"
  homepage "https://cityinthesky.co.uk/opensource/pdf2svg"
  url "https://github.com/dawbarton/pdf2svg/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "4fb186070b3e7d33a51821e3307dce57300a062570d028feccd4e628d50dea8a"
  license "GPL-2.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d8eeaafdf393cfa6a111959c4b64ded4dc4111c0706a823f25dcbda06c105b92"
    sha256 cellar: :any,                 arm64_sonoma:   "c1ee5db9b628526a6a4cf4bee28826288ca7bb77cd5af8ddf96a24a91f952577"
    sha256 cellar: :any,                 arm64_ventura:  "397a10a14de7d93121d1939aa4428ee31077e8a3f0da4850c49803fef0172805"
    sha256 cellar: :any,                 arm64_monterey: "59c454529b5b0a0f5361f9e46d4e73b9cf13a449690fd9dcb1b9a8eeafc32428"
    sha256 cellar: :any,                 arm64_big_sur:  "dc5018cf8ccb7b474fe5c575d562c59e361c3c251ce88d9e36b7636d1f77ef3b"
    sha256 cellar: :any,                 sonoma:         "30b2967d0fbfe064fec3da3360851983198c79f48c8057459f9b6e54b9db4c8d"
    sha256 cellar: :any,                 ventura:        "7bc9679fe99636111bebf89f8fc849e5c1e3005fb480d4cb0b718589405829bd"
    sha256 cellar: :any,                 monterey:       "ef550db355bae0f4fd507e13f7b71a7fc3cabce0ac126933dda9dc46539931d9"
    sha256 cellar: :any,                 big_sur:        "3a8d825e70e419c4f7cc783d472eec8cd384764c351c131780c2a0b691cda24d"
    sha256 cellar: :any,                 catalina:       "a2af2e44c752994638edbd3aa7684290d116d20f1da2fe3e4490527be5b23bac"
    sha256 cellar: :any,                 mojave:         "b0cf8046c13335a16496cc5601af7a82f14b45c866cf9f3ae9072075ccc867fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2524e6d0eecc059f7135c92554ba25a781cb29c32335a6af8d4db24571dd3b82"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "poppler"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    system bin/"pdf2svg", test_fixtures("test.pdf"), "test.svg"
  end
end
