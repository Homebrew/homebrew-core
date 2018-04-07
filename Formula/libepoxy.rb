class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.0.tar.xz"
  sha256 "4c94995398a6ebf691600dda2e9685a0cac261414175c2adf4645cdfab42a5d5"
  revision 1

  bottle do
    cellar :any
    sha256 "068e7418ed83a620e757f4210e4813becf5cc3d6290a7e9b182c375561d0e928" => :high_sierra
    sha256 "daf5823671b71966017dfc59506b850824be070ecb13ee600b8b391e98a66b12" => :sierra
    sha256 "fd2bff08ce59cbf35dd0ba15e7b0d2bb53babd788ce5240dcfd948f0e68ef2e2" => :el_capitan
  end

  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build

  # submitted upstream at https://github.com/anholt/libepoxy/pull/156
  patch :DATA

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS

      #include <epoxy/gl.h>
      #include <OpenGL/CGLContext.h>
      #include <OpenGL/CGLTypes.h>
      int main()
      {
          CGLPixelFormatAttribute attribs[] = {0};
          CGLPixelFormatObj pix;
          int npix;
          CGLContextObj ctx;

          CGLChoosePixelFormat( attribs, &pix, &npix );
          CGLCreateContext(pix, (void*)0, &ctx);

          glClear(GL_COLOR_BUFFER_BIT);
          CGLReleasePixelFormat(pix);
          CGLReleaseContext(pix);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lepoxy", "-framework", "OpenGL", "-o", "test"
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end

__END__
diff --git a/src/meson.build b/src/meson.build
index 3401075..031900f 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -57,11 +57,6 @@ if host_system == 'linux'
   endforeach
 endif

-# Maintain compatibility with autotools; see: https://github.com/anholt/libepoxy/issues/108
-if host_system == 'darwin'
-  common_ldflags += [ '-compatibility_version 1', '-current_version 1.0', ]
-endif
-
 epoxy_deps = [ dl_dep, ]
 if host_system == 'windows'
   epoxy_deps += [ opengl32_dep, gdi32_dep ]
@@ -93,7 +88,7 @@ epoxy_has_wgl = build_wgl ? '1' : '0'
 # not needed when building Epoxy; we do want to add them to the generated
 # pkg-config file, for consumers of Epoxy
 gl_reqs = []
-if gl_dep.found()
+if gl_dep.found() and host_system != 'darwin'
   gl_reqs += 'gl'
 endif
 if build_egl and egl_dep.found()

