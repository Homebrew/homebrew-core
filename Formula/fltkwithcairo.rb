class Fltkwithcairo < Formula
  desc "Latest non-stable branch of FLTK *with* Cairo support enabled"
  homepage "http://www.fltk.org/"
  url "http://fltk.org/pub/fltk/snapshots/fltk-1.4.x-r13071.tar.gz"
  version "1.4.x-r13071"
  sha256 "09ea8ae57aa5a5c0e017607d69e4beba0227181e431a9cbb54c1dfa5d082e3b3"

  depends_on "cairo"
  depends_on "jpeg"
  depends_on "libpng"

  def install
    archcmd = "uname -m"
    sysarch = `#{archcmd}`.tr("\n", "")
    compiler_flags = " -g -DBUILD_SHARED_LIBS -D__APPLE__"
    include_flags = " -I /usr/local/opt/cairo/include/cairo"
    config_args = [
      "--prefix=#{prefix}",
      "--enable-cairo",
      "--enable-threads",
      "CC=clang" + compiler_flags + " -arch " + sysarch + include_flags,
      "CXX=clang++" + compiler_flags + " -arch " + sysarch + include_flags,
    ]
    system "make", "clean"
    system "./configure", *config_args
    system "make", "install"
  end

  test do
    system "false"
  end
end
