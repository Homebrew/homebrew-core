class Movgrab < Formula
  desc "Downloader for youtube, dailymotion, and other video websites"
  homepage "https://sites.google.com/site/columscode/home/movgrab"
  url "https://github.com/ColumPaget/Movgrab/archive/3.1.2.tar.gz"
  sha256 "30be6057ddbd9ac32f6e3d5456145b09526cc6bd5e3f3fb3999cc05283457529"

  bottle do
    cellar :any_skip_relocation
    sha256 "aed3c8c31bbfa27328292f4be3fd0a184c02f11c3605d64fa6c67b1c793646bf" => :catalina
    sha256 "cde671dc6401286e39179deff8598a78e7df1184b420178a178900f505ac4221" => :mojave
    sha256 "32d047668237fab4e3dea9987bce5d568a86b7846d671dffabcecd5aaf42ddfe" => :high_sierra
    sha256 "aa40b9cb2e4c947ced14535bcb0e4bf189cf90ca786a7386b372abc6e92ed90a" => :sierra
    sha256 "82cb6ea3423aabf6ae277fcdb2d6ae497021ba5ea7b9c58d6f3553ecebe1bb17" => :el_capitan
    sha256 "aac759c0e0b95b7ccf0e9a446d78e360be70aacf43f341eb1f785e8c7396b8cc" => :yosemite
    sha256 "f36f583c82bf0b4fda8b918fde44d0631950544c48f313ac3ed52b9dee6af7de" => :mavericks
  end

  depends_on "libressl"

  def install
    # libUseful's configure script incorrectly detects macOS's getxattr functions,
    # expecting them to be functionally equivalent to Linux's. They're not!
    ENV["ac_cv_lib_c_getxattr"] = "no"
    ENV["ac_cv_lib_c_setxattr"] = "no"

    # Can you believe this? A forgotten semicolon! Probably got missed because it's
    # behind a conditional #ifdef.
    inreplace "libUseful-2.8/FileSystem.c", "result=-1", "result=-1;"

    # Later versions of libUseful handle the fact that setresuid is Linux-only, but
    # this one does not. https://github.com/ColumPaget/Movgrab/blob/master/libUseful/Process.c#L95-L99
    inreplace "libUseful-2.8/Process.c", "setresuid(uid,uid,uid)", "setreuid(uid,uid)"

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-ssl"
    system "make"

    # because case-insensitivity is sadly a thing and while the movgrab
    # Makefile itself doesn't declare INSTALL as a phony target, we
    # just remove the INSTALL instructions file so we can actually
    # just make install
    rm "INSTALL"
    system "make", "install"
  end

  test do
    system "#{bin}/movgrab", "--version"
  end
end
