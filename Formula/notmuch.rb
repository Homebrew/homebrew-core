class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org"
  url "https://notmuchmail.org/releases/notmuch-0.26.tar.gz"
  sha256 "d3e894ed2ad9d721a442663f07a6f2a241dc98be7cc4af681f16edf88e0d76df"
  head "git://notmuchmail.org/git/notmuch"

  bottle do
    cellar :any
    sha256 "4a4c6981dbc9cc1061f30a9e571c729372edc52d235ac3682b6711ff19b2c136" => :high_sierra
    sha256 "ec47c28caf199263d0c11301b42a29ce2326c3201a12ac20c687412db2c39555" => :sierra
    sha256 "9fd854188d76d174dbd6d19eea001923403c908f33e11aff98cf135f58eb69a2" => :el_capitan
  end

  option "without-python", "Build without python support"

  depends_on "pkg-config" => :build
  depends_on "libgpg-error" => :build
  depends_on "glib"
  depends_on "gmime"
  depends_on "talloc"
  depends_on "xapian"
  depends_on "zlib"
  depends_on "emacs" => :optional
  depends_on "python3" => :optional
  depends_on "ruby" => :optional

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
