class Ncftp < Formula
  desc "FTP client with an advanced user interface"
  homepage "https://www.ncftp.com/"
  url "https://www.ncftp.com/public_ftp/ncftp/ncftp-3.3.0-src.tar.gz"
  mirror "https://fossies.org/linux/misc/ncftp-3.3.0-src.tar.gz"
  sha256 "7920f884c2adafc82c8e41c46d6f3d22698785c7b3f56f5677a8d5c866396386"
  license "ClArtistic"

  livecheck do
    url "https://www.ncftp.com/download/"
    regex(/href=.*?ncftp[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d034873e2efd9f27eaf30e71a66222e1c36de002f2e2097916558bb0ddc7409c"
    sha256 arm64_sequoia: "7be8e9dfbc09cdbfef04c5568b799d84a9155032e365bfc00e6b92ca9ad05c9d"
    sha256 arm64_sonoma:  "676773ed103a6eb600332b73cc4686a7c7ef01cec09dc4fc49df6c868489d02e"
    sha256 arm64_ventura: "826e54b963b9f4552b09149a5ec0f9a78005185d8ca76da200b18c69fe69dd73"
    sha256 sonoma:        "0ee04c4edb6b7b3947ffb8733cb4d574594332bbcd6ea70440457374b05b0186"
    sha256 ventura:       "e99af095f88ba709589a6c45681ac5edac1930a1fb907cdec847d17e9b5972a4"
    sha256 arm64_linux:   "b3171b27e7ed8520f11f75cf478561730cfffe5fb3bdbf7f29d46882bce1f7e9"
    sha256 x86_64_linux:  "8936a27e03427f0ceae15bddc40bc744c4451bcc3a8ca564f498c50776d7c406"
  end

  uses_from_macos "ncurses"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    system "./configure", "--disable-universal",
                          "--disable-precomp",
                          "--with-ncurses",
                          "--mandir=#{man}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"ncftp", "-F"
  end
end
