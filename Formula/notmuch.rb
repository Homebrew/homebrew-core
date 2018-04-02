class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org"
  url "https://notmuchmail.org/releases/notmuch-0.26.1.tar.gz"
  sha256 "d3f7e44f4dd0a75150b73e41737c4923ba94ea2947b9fe585f0aab591bb4a837"
  head "git://notmuchmail.org/git/notmuch"

  bottle do
    cellar :any
    sha256 "761b36b62e0e0990e4e088ca165a663c0fc4689e46ead4f054d68764b9e8dbe1" => :high_sierra
    sha256 "4d06aca8e291ceeef2847d11d84fceccc769538b912fe626c9c1bc0827514886" => :sierra
    sha256 "c2f773b85a7f06cd693cd2aa1947b240e8b769d802c22151fc62fe0ec1aa8ccb" => :el_capitan
  end

  option "without-python@2", "Build without python2 support"

  deprecated_option "with-python3" => "with-python"
  deprecated_option "without-python" => "without-python@2"

  depends_on "doxygen" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "gmime"
  depends_on "talloc"
  depends_on "xapian"
  depends_on "zlib"
  depends_on "python@2" => :recommended if MacOS.version <= :snow_leopard
  depends_on "emacs" => :optional
  depends_on "python" => :optional
  depends_on "ruby" => :optional

  # Fix SIP issue with python bindings
  # A more comprehensive patch has been submitted upstream
  # https://notmuchmail.org/pipermail/notmuch/2016/022631.html
  patch :DATA

  def install
    # configure runs `python -m sphinx.writers.manpage` to detect if
    # `sphinx-build` will work
    ENV.prepend_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"lib/python2.7/site-packages"

    args = %W[--prefix=#{prefix} --mandir=#{man}]

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
