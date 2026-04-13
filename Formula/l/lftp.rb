class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://github.com/lavv17/lftp/releases/download/v4.9.3/lftp-4.9.3.tar.gz"
  sha256 "68116cc184ab660a78a4cef323491e89909e5643b59c7b5f0a14f7c2b20e0a29"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "d18f0124b629090aea7a35fc4a860e63e55c25cf21534acf8293d91ce52112a4"
    sha256 arm64_sequoia: "8977a9fa5c15417e34d2564d95715064292d65b200c1ad704147ee555c542810"
    sha256 arm64_sonoma:  "ab4a8500603f5bc678a185a8de4babc442fbbda9efdef3e4ab7bbcd32df5a42c"
    sha256 sonoma:        "e71c6bca446546bbf15228bbbce5f49294f1180fa36bfdb42afc9309dbbe09fe"
    sha256 arm64_linux:   "14c4eeb37d1458cb5a2ee7e1bbab6485c598e93ab126155ff773c3da5ab9f05e"
    sha256 x86_64_linux:  "6ed8ee10b71dbbaa5dfa5d7451840592d30598730a325d749360d7f1e6472f83"
  end

  depends_on "libidn2"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Fix compile with newer Clang
    # https://github.com/lavv17/lftp/issues/611
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    system "./configure", "--disable-silent-rules",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libidn2=#{Formula["libidn2"].opt_prefix}",
                          *std_configure_args

    system "make", "install"
  end

  test do
    system bin/"lftp", "-c", "open https://ftpmirror.gnu.org/; ls"
  end
end
