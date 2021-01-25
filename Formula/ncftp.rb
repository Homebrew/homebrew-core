class Ncftp < Formula
  desc "FTP client with an advanced user interface"
  homepage "https://www.ncftp.com/"
  url "https://mirrorservice.org/sites/ftp.ncftp.com/ncftp/ncftp-3.2.6-src.tar.gz"
  mirror "https://fossies.org/linux/misc/ncftp-3.2.6-src.tar.gz"
  sha256 "129e5954850290da98af012559e6743de193de0012e972ff939df9b604f81c23"
  license "ClArtistic"

  livecheck do
    url "https://www.ncftp.com/download/"
    regex(/href=.*?ncftp[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t/i)
  end

  bottle do
    rebuild 1
    sha256 "be10854d86393b58f542fbe778bf650c90a9635fbd14eff8149459838c4455c6" => :big_sur
    sha256 "1fc3f5a43b5e4e23f2bac0046acaf8f746d5d07e0eb6cf60d593830fb3acbf13" => :arm64_big_sur
    sha256 "c5759f94e328047e35a3f22c63ecf7bf7051edbc68432b3eb9db6c61d8f84bb2" => :catalina
    sha256 "381492aa09e004859600ffc441ebd4dfe1c75685099debf5a7c283c15785a26c" => :mojave
  end

  uses_from_macos "ncurses"

  def install
    # Work around ./configure issues with Xcode 12:
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "./configure", "--disable-universal",
                          "--disable-precomp",
                          "--with-ncurses",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ncftp", "-F"
  end
end
