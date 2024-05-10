class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/"
  url "https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.3.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-1.3.0.tar.bz2"
  sha256 "9b3cd5226e7597f2fded399a3bc659923351536559e9db0826981bca316494de"
  license "GPL-2.0-only"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/pinentry/"
    regex(/href=.*?pinentry[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "929d0da215b25c904bd6745e6f61d778384857cd45221382670f72bf94d04968"
    sha256 cellar: :any,                 arm64_ventura:  "90851b4108753f8b10f6c084200348809d3e306f5bf766fe8ba42b5358acd909"
    sha256 cellar: :any,                 arm64_monterey: "14a6bd33b369d31d49e3e95c825b30cb17999412713c8d5fa9fa063aded47398"
    sha256 cellar: :any,                 sonoma:         "bbcc4d94c528861d9d3823ad697f65b6e15562f80ca671beb723b338079c7024"
    sha256 cellar: :any,                 ventura:        "f2f61b16e0cab610927e312be8cdff73c9b2a6da7fe97fde09e3b0ee27d01823"
    sha256 cellar: :any,                 monterey:       "901f46be67b462a5939b59e4cd525b335522f091bde44a0d773b289f4a7f957b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cf5904bae7ec29fa198f7af8d75d0889286933e87c9886ab5c7a78e1aa72c9f"
  end

  depends_on "pkg-config" => :build
  depends_on "libassuan"
  depends_on "libgpg-error"

  on_linux do
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
    system "#{bin}/pinentry", "--version"
    system "#{bin}/pinentry-tty", "--version"
  end
end
