class GtkVnc < Formula
  desc "VNC viewer widget for GTK."
  homepage "https://wiki.gnome.org/Projects/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/0.5/gtk-vnc-0.5.4.tar.xz"
  sha256 "488aa97a76ce6868160699cd45d4a0ee0fe6f0ad4631737c6ddd84450f6c9ce7"

  bottle do
    sha256 "3e542006e50dab1ec526b46a4a8f4e7f2cb81028141f511329c7ece9d615bfa2" => :el_capitan
    sha256 "649dcb517d936e72da2c8e3cff67cd200c51a0b6ebfe60d70bb5f40c03bebf8b" => :yosemite
    sha256 "9d47fee65e698a59d2f90b53f47937745bdd627e0e7e8877daa65192068de7ee" => :mavericks
  end

  depends_on "gettext" => :build
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "intltool" => :build
  depends_on "libgcrypt"
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "gobject-introspection" => :optional
  depends_on "pulseaudio" => :optional
  depends_on "vala" => :optional

  # Fix build failure with xcode 7.1 or older.
  # Upstream bug: https://bugzilla.gnome.org/show_bug.cgi?id=602371
  patch :DATA if MacOS.version < :el_capitan

  def install
    args = %W[
      --prefix=#{prefix}
      --with-gtk=3.0
      --with-examples
      --with-python
    ]

    args << "--enable-introspection" if build.with? "gobject-introspection"
    args << "--enable-pulseaudio" if build.with? "pulseaudio"
    if build.with? "vala"
      args << "--enable-vala"
    else
      args << "--disable-vala"
    end

    # fix "The deprecated ucontext routines require _XOPEN_SOURCE to be defined"
    ENV.append "CPPFLAGS", "-D_XOPEN_SOURCE=600"
    # for MAP_ANON
    ENV.append "CPPFLAGS", "-D_DARWIN_C_SOURCE"

    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gvncviewer", "--help-all"
  end
end

__END__
diff --git a/src/continuation.h b/src/continuation.h
index 46f7a71..1b97207 100644
--- a/src/continuation.h
+++ b/src/continuation.h
@@ -21,6 +21,7 @@
 #ifndef _CONTINUATION_H_
 #define _CONTINUATION_H_

+#include <sys/types.h>
 #include <ucontext.h>

 struct continuation
diff --git a/src/coroutine_ucontext.c b/src/coroutine_ucontext.c
index 8fe650e..600f726 100644
--- a/src/coroutine_ucontext.c
+++ b/src/coroutine_ucontext.c
@@ -63,6 +63,9 @@ int coroutine_init(struct coroutine *co)
     co->cc.stack_size = co->stack_size;
     co->cc.stack = mmap(0, co->stack_size,
                         PROT_READ | PROT_WRITE,
+#if !defined(MAP_ANONYMOUS)
+#  define MAP_ANONYMOUS MAP_ANON
+#endif
                         MAP_PRIVATE | MAP_ANONYMOUS,
                         -1, 0);
     if (co->cc.stack == MAP_FAILED)
