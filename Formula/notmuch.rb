class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org"
  url "https://notmuchmail.org/releases/notmuch-0.25.tar.gz"
  sha256 "65d28d1f783d02629039f7d15d9a2bada147a7d3809f86fe8d13861b0f6ae60b"
  revision 1
  head "git://notmuchmail.org/git/notmuch"

  bottle do
    cellar :any
    sha256 "e1e33e5b0eb0014ab8818c000f130a6a607cb0a7afe238b89e8d1856e783b29e" => :sierra
    sha256 "9fcf28d4231dc5d8677a92e1d606276bb1432a8772494f2aea7763794e09b6a0" => :el_capitan
    sha256 "273a87181ae3ed06ffc8d3f90462913d3b23f509b53a4a9cf5c8e0ac01be8d92" => :yosemite
  end

  option "without-python", "Build without python support"

  depends_on "pkg-config" => :build
  depends_on "libgpg-error" => :build
  depends_on "glib"
  depends_on "gmime"
  depends_on "talloc"
  depends_on "xapian"
  depends_on "zlib"
  depends_on :emacs => ["24.1", :optional]
  depends_on :python3 => :optional
  depends_on :ruby => ["1.9", :optional]

  # Fix SIP issue with python bindings
  # A more comprehensive patch has been submitted upstream
  # https://notmuchmail.org/pipermail/notmuch/2016/022631.html
  patch :DATA

  def install
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
