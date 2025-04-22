class Ncftp < Formula
  desc "FTP client with an advanced user interface"
  homepage "https://www.ncftp.com/"
  url "https://www.ncftp.com/public_ftp/ncftp/ncftp-3.2.9-src.tar.gz"
  mirror "https://fossies.org/linux/misc/ncftp-3.2.9-src.tar.gz"
  sha256 "f1108e77782376f8aec691f68297a3364a9a7c2d9bb12e326f550ff9770f47a7"
  license "ClArtistic"

  livecheck do
    url "https://www.ncftp.com/download/"
    regex(/href=.*?ncftp[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "6bbc37b40d42be6e959411ad72917fed344adf99ce5f4baf167f9c7815ccc10b"
    sha256 arm64_sonoma:  "1b49b2182fb22d3f063198adb60bded9b49476e645e17eb69163e19748547a4e"
    sha256 arm64_ventura: "b28e8aecc23cd97394c5b7a282e4c8abf544fdcc6c9f2b216c3fec4b5105dda6"
    sha256 sonoma:        "7de0b98c69c496d986b3125990c8e0605c925c436533968fe313fafa295a5563"
    sha256 ventura:       "39e3426de0ffde35421a3cf731d65e68e0a5cd27bd21363273524969f4bce664"
    sha256 arm64_linux:   "41b15795fc9b435b37273c841150442468ec8e7294dc49533d7fbca18fcc24a4"
    sha256 x86_64_linux:  "633b2189e8667112b0d8edd3cf293fcbb18602fd75e51b16257f83e891719896"
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
