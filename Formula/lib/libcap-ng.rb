class LibcapNg < Formula
  desc "Library for Linux that makes using posix capabilities easy"
  homepage "https://people.redhat.com/sgrubb/libcap-ng"
  url "https://people.redhat.com/sgrubb/libcap-ng/libcap-ng-0.8.4.tar.gz"
  sha256 "68581d3b38e7553cb6f6ddf7813b1fc99e52856f21421f7b477ce5abd2605a8a"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3762e67587dbdae0a476f3e25a2b7f6274a6328cf8f9ca3304857d995907b9be"
  end

  head do
    url "https://github.com/stevegrubb/libcap-ng.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "m4" => :build
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "swig" => :build
  depends_on :linux

  # Compat for latest swig, removing deprecated `%except` directive
  # https://github.com/stevegrubb/libcap-ng/commit/30453b6553948cd05c438f9f509013e3bb84f25b
  patch :DATA

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-python3"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <cap-ng.h>

      int main(int argc, char *argv[])
      {
        if(capng_have_permitted_capabilities() > -1)
          printf("ok");
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcap-ng", "-o", "test"
    assert_equal "ok", `./test`
    system "python3.12", "-c", "import capng"
  end
end

__END__
diff --git a/bindings/src/capng_swig.i b/bindings/src/capng_swig.i
index fcdaf18..fa85e13 100644
--- a/bindings/src/capng_swig.i
+++ b/bindings/src/capng_swig.i
@@ -30,13 +30,6 @@
 
 %varargs(16, signed capability = 0) capng_updatev;
 
-%except(python) {
-  $action
-  if (result < 0) {
-    PyErr_SetFromErrno(PyExc_OSError);
-    return NULL;
-  }
-}
 #endif
 
 %define __signed__
