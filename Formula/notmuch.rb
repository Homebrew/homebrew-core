class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org"
  url "https://notmuchmail.org/releases/notmuch-0.27.tar.gz"
  sha256 "40d3192f8f130f227b511fc80be86310c7f60ccb6d043b563f201fa505de0876"
  head "git://notmuchmail.org/git/notmuch"

  bottle do
    cellar :any
    sha256 "051ebe84019bba0cb4cae615916e357713252e47c01aea065225b1b2f51765ef" => :mojave
    sha256 "4695a937a8e9debbeb27dfd880c7ecef2ae52b3efbaa124fe11417c6891856f1" => :high_sierra
    sha256 "a0d4a811d4f7c28de66361b669269198614b73e987e26d2ed5a7238786167766" => :sierra
    sha256 "3f2af1545594e7a3c2d42643dfabbdc4ba5a106bfd7927e325cea3bcc68e979c" => :el_capitan
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
  depends_on "python@2" => :recommended
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

    if build.with? "ruby"
      cd "bindings/ruby" do
        # Prevent Makefile from trying to break free of the
        # sandbox and mkdir in HOMEBREW_PREFIX.
        inreplace "Makefile", HOMEBREW_PREFIX/"lib/ruby", lib/"ruby"
        system "make", "install"
      end
    end

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
