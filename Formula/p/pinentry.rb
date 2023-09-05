class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/"
  url "https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.2.1.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-1.2.1.tar.bz2"
  sha256 "457a185e5a85238fb945a955dc6352ab962dc8b48720b62fc9fa48c7540a4067"
  license "GPL-2.0-only"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/pinentry/"
    regex(/href=.*?pinentry[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bf9663328a2b2d04479530fd7aa6053a3bf83c2f33ba1258d8eaafb94bb84060"
    sha256 cellar: :any,                 arm64_monterey: "5a929b4926da533a676b19d3cb1225b796a4046e08fd922a9784422b67dff29d"
    sha256 cellar: :any,                 arm64_big_sur:  "6648d2c2231940d6d1543f934045c6d172a68cbec3653ff70ca63c4281f047ae"
    sha256 cellar: :any,                 ventura:        "b2f9200f41078da0b832121d708367b3c42116c11bf306851580f16541cc145f"
    sha256 cellar: :any,                 monterey:       "14dd6cb2c084a534214607f68d0876035f8e8aaeb452c374aa41adbe0231511a"
    sha256 cellar: :any,                 big_sur:        "51144f3f5a2eacd6c13e34d44975d025981c38c1815dc4d7cbd062ddbe23e12a"
    sha256 cellar: :any,                 catalina:       "df23306e11505b962ab871fd30f1cd6e1694440ede2a9692a68e4ae2da1569c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d75a7ffda7ba40c207144f82620c9bbfef7b52bad50d9b3bf4addc3235783978"
  end

  depends_on "pkg-config" => :build
  depends_on "libassuan"
  depends_on "libgpg-error"

  on_linux do
    depends_on "libsecret"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-pinentry-fltk
      --disable-pinentry-gnome3
      --disable-pinentry-gtk2
      --disable-pinentry-qt
      --disable-pinentry-qt5
      --disable-pinentry-tqt
      --enable-pinentry-tty
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pinentry", "--version"
    system "#{bin}/pinentry-tty", "--version"
  end
end
