class Libgpm < Formula
  desc "general purpose mouse"
  homepage "http://www.nico.schottelius.org/software/gpm/"
  url "http://www.nico.schottelius.org/software/gpm/archives/gpm-1.20.7.tar.bz2"
  sha256 "f011b7dc7afb824e0a017b89b7300514e772853ece7fc4ee640310889411a48d"
  # tag "linuxbrew"

  bottle do
    cellar :any
    sha256 "7aec47e93bf034b08d3376ce35e75c87e0dd4995917f5f0727b0297189e02af8" => :x86_64_linux
  end

  head "https://github.com/telmich/gpm.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "bison" => :build
  depends_on "texinfo" => :build
  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  patch :DATA
  patch do
    url "https://patch-diff.githubusercontent.com/raw/telmich/gpm/pull/14.patch"
    sha256 "53c7d470ccdad04a769223995c085e4b3d46f8931bc4febfa75bd7bd9519a937"
  end

  def install
    ENV.deparallelize

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/gpm", "-v"
  end
end

__END__
diff --git a/acinclude.m4 b/acinclude.m4
index a932e3a..1e828d0 100644
--- a/acinclude.m4
+++ b/acinclude.m4
@@ -22,7 +22,7 @@ AC_DEFUN([ITZ_PATH_SITE_LISP],
 sed -e '/^$/d' | sed -n -e 2p`
 case x${itz_cv_path_site_lisp} in
 x*site-lisp*) ;;
-x*) itz_cv_path_site_lisp='${datadir}/emacs/site-lisp' ;;
+x*) itz_cv_path_site_lisp='${datadir}/emacs/site-lisp/libgpm' ;;
 esac])
 ])
 AC_DEFUN([ITZ_CHECK_TYPE],
