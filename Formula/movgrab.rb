class Movgrab < Formula
  desc "Downloader for youtube, dailymotion, and other video websites"
  homepage "https://sites.google.com/site/columscode/home/movgrab"
  url "https://github.com/ColumPaget/Movgrab/archive/3.1.2.tar.gz"
  sha256 "30be6057ddbd9ac32f6e3d5456145b09526cc6bd5e3f3fb3999cc05283457529"

  bottle do
    cellar :any
    sha256 "3256dfc0f04850842d1ed0580d56ed6ef2929b51bde9dab3b7ddded980e8c527" => :catalina
    sha256 "790aca486dbbff6d41ae8d61b99a1de73085b837625736dee323bf251ebd6609" => :mojave
    sha256 "465f017e9d4c849aefa02d1471e12625b4a98e8f425323f6966e0b81cd286a27" => :high_sierra
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
