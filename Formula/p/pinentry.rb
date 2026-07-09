class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/"
  url "https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.3.3.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-1.3.3.tar.bz2"
  sha256 "c2970f16d6afb66ecddfca767d743936c86239bff936eed7fd7597a678414b63"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/pinentry/"
    regex(/href=.*?pinentry[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "21e2614c38af0287f96dd0c288dea2c13bfbb7810ce1d6e659ed82e5c2073c92"
    sha256 cellar: :any, arm64_sequoia: "eb7ffd4b8a4f31ce85cf0395656bbc1fd5241fdc1b9f92d9900e813993d4e1e0"
    sha256 cellar: :any, arm64_sonoma:  "e4a96896da1a1a8f6ff7e95dfc39cd3f39d8200a51ef4e1e3097b93aec01088b"
    sha256 cellar: :any, sonoma:        "590157c44b9ac5eadfdfac5d46897d720ff8d09ef4b64514acaa46432b8d3e1f"
    sha256 cellar: :any, arm64_linux:   "898bda8003ce5f9e51689351dc6853c0fdde77a0d1d3cc68fd431452b558f2f8"
    sha256 cellar: :any, x86_64_linux:  "b5e23cb72d88f6ea3c9c9f95aa356231ea072dd8f91886249154366db8ea6c69"
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
