class Iozone < Formula
  desc "File system benchmark tool"
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_465.tar"
  sha256 "2e3d72916e7d7340a7c505fc0c3d28553fcc5ff2daf41d811368e55bd4e6a293"

  bottle do
    cellar :any_skip_relocation
    sha256 "8de42bd9a07de561ab96d8e8e1f5bb7e080e6b4b447e2530959c78dcd090cba6" => :sierra
    sha256 "d40abf2cadeefd00d48a82b4087a652a53e7b306b3ad87597293c24c352a36f7" => :el_capitan
  end

  # Patch by @nijotz, adds O_DIRECT support when using -I flag.
  # See: https://github.com/Homebrew/homebrew/pull/10585
  patch :DATA

  # Fix build failure "error: conflicting types for 'mythread_create'"
  # Reported 10 Sep 2017 to capps AT iozone DOT org
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/56c6104/iozone/mythread_create.diff"
    sha256 "ec1a1be0d0096c29711f2edba50c8183cfde886a55f18b41c2c7d1580d8f68c8"
  end

  def install
    cd "src/current" do
      system "make", "macosx", "CC=#{ENV.cc}"
      bin.install "iozone"
      pkgshare.install %w[Generate_Graphs client_list gengnuplot.sh gnu3d.dem
                          gnuplot.dem gnuplotps.dem iozone_visualizer.pl
                          report.pl]
    end
    man1.install "docs/iozone.1"
  end

  test do
    assert_match "File size set to 16384 kB",
      shell_output("#{bin}/iozone -I -s 16M")
  end
end

__END__
--- a/src/current/iozone.c      2011-12-16 09:17:05.000000000 -0800
+++ b/src/current/iozone.c      2012-02-28 16:57:58.000000000 -0800
@@ -1820,7 +1810,7 @@
 			break;
 #endif
 #if ! defined(DONT_HAVE_O_DIRECT)
-#if defined(linux) || defined(__AIX__) || defined(IRIX) || defined(IRIX64) || defined(Windows) || defined(__FreeBSD__) || defined(solaris)
+#if defined(linux) || defined(__AIX__) || defined(IRIX) || defined(IRIX64) || defined(Windows) || defined(__FreeBSD__) || defined(solaris) || defined(macosx)
 			direct_flag++;
 			sprintf(splash[splash_line++],"\tO_DIRECT feature enabled\n");
 			break;
