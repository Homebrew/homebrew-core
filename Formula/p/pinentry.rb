class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/"
  url "https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.3.2.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-1.3.2.tar.bz2"
  sha256 "8e986ed88561b4da6e9efe0c54fa4ca8923035c99264df0b0464497c5fb94e9e"
  license "GPL-2.0-only"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/pinentry/"
    regex(/href=.*?pinentry[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8db428e52232580a5acf1da5a370c39c425e5320a28e967ae091f1c82596b50a"
    sha256 cellar: :any,                 arm64_sequoia: "f6dfd4bfdda001ddfddbed01c6ad7e06408ff022788a7718d35e443ebcb31274"
    sha256 cellar: :any,                 arm64_sonoma:  "45317e1d4023306c38e0118f48f75fbdc09df2b22ca0428f747ad4844413bd2c"
    sha256 cellar: :any,                 arm64_ventura: "114df538a9d7172db7eb15b1c1380617fe8e7f3da735d1941dd3fef520aeaeec"
    sha256 cellar: :any,                 sonoma:        "d0efed8b2727ae08821905faaae114946dc6ca476acc9e64f05b9d54923ec965"
    sha256 cellar: :any,                 ventura:       "d5febb0ffec00281abc40d54ebf90929861452ea2a9dee1394a54f9ccb96dc3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5b34aeb57f37731401747e632485c6e5d8d6b60f1e025323558d7b0b3dac96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92da639e8c37468025b9464abc36f6b15d13a2a096c25c0c860450745c7d696d"
  end

  depends_on "pkgconf" => :build
  depends_on "libassuan"
  depends_on "libgpg-error"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    args = %w[
      --disable-silent-rules
      --disable-pinentry-fltk
      --disable-pinentry-gnome3
      --disable-pinentry-gtk2
      --disable-pinentry-qt
      --disable-pinentry-qt5
      --disable-pinentry-tqt
      --enable-pinentry-tty
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"pinentry", "--version"
    system bin/"pinentry-tty", "--version"
  end
end
