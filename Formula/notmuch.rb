class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org"
  url "https://notmuchmail.org/releases/notmuch-0.24.tar.gz"
  sha256 "f7e44cf67630669d3537c4febd7685ca27d62a134e42f9a5db90d5a6ed4c75fc"

  bottle do
    cellar :any
    sha256 "ebf9b8c0f49053b510e31ee5dcebc2dd9913ae18783a28ebe52afa234f0659a5" => :sierra
    sha256 "c83777b82c72ba322b6900fcc0464d49ff3efc381e1cbaa6af35cb38130d113b" => :el_capitan
    sha256 "4f9a747e5540b0729e8769b851bc413de636f985be1198274a44e413f6e6676b" => :yosemite
  end

  option "without-python", "Build without python support"

  depends_on "pkg-config" => :build
  depends_on "gmime"
  depends_on "talloc"
  depends_on "xapian"
  depends_on :emacs => ["24.1", :optional]
  depends_on :python3 => :optional
  depends_on :ruby => ["1.9", :optional]

  # Requires zlib >= 1.2.11
  resource "zlib" do
    url "http://zlib.net/zlib-1.2.11.tar.gz"
    sha256 "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"
  end

  # Fix SIP issue with python bindings
  # A more comprehensive patch has been submitted upstream
  # https://notmuchmail.org/pipermail/notmuch/2016/022631.html
  patch :DATA

  def install
    resource("zlib").stage do
      system "./configure", "--prefix=#{buildpath}/zlib", "--static"
      system "make", "install"
      ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/zlib/lib/pkgconfig"
    end

    args = %W[--prefix=#{prefix}]

    if build.with? "emacs"
      ENV.deparallelize # Emacs and parallel builds aren't friends
      args << "--with-emacs" << "--emacslispdir=#{elisp}" << "--emacsetcdir=#{elisp}"
    else
      args << "--without-emacs"
    end

    args << "--without-ruby" if build.without? "ruby"

    system "./configure", *args
    system "make", "V=1", "install"

    Language::Python.each_python(build) do |python, _version|
      cd "bindings/python" do
        system python, *Language::Python.setup_install_args(prefix)
      end
    end
  end

  test do
    (testpath/".notmuch-config").write "[database]\npath=#{testpath}/Mail"
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")
  end
end

__END__
diff --git a/bindings/python/notmuch/globals.py b/bindings/python/notmuch/globals.py
index b1eec2c..bce5190 100644
--- a/bindings/python/notmuch/globals.py
+++ b/bindings/python/notmuch/globals.py
@@ -25,7 +25,7 @@ from notmuch.version import SOVERSION
 try:
     from os import uname
     if uname()[0] == 'Darwin':
-        nmlib = CDLL("libnotmuch.{0:s}.dylib".format(SOVERSION))
+        nmlib = CDLL("HOMEBREW_PREFIX/lib/libnotmuch.{0:s}.dylib".format(SOVERSION))
     else:
         nmlib = CDLL("libnotmuch.so.{0:s}".format(SOVERSION))
 except:
