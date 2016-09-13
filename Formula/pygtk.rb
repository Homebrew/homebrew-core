class Pygtk < Formula
  desc "GTK+ bindings for Python"
  homepage "http://www.pygtk.org/"
  url "https://download.gnome.org/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2"
  sha256 "cd1c1ea265bd63ff669e92a2d3c2a88eb26bcd9e5363e0f82c896e649f206912"
  revision 1

  bottle do
    cellar :any
    rebuild 2
    sha256 "89f5d6762155b369dae255ba2b3952cc09f43f899585ff8694370b6b151ca97e" => :sierra
    sha256 "bfea679c1a46b35c7788a692869ddb576c2869900d25b72f6cf91e25edc409a9" => :el_capitan
    sha256 "7b008b213a675e96a83edb7b1be8401bbc9bbeb5db9a926104897f99a8d7d61e" => :yosemite
    sha256 "603694d87d2c6193caa164029bc441d93d45cdcd75419c8f8ed11b0902577457" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+"
  depends_on "atk"
  depends_on "pygobject"
  depends_on "py2cairo"
  depends_on "libglade" => :optional

  def install
    ENV.append "CFLAGS", "-ObjC"
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # Fixing the pkgconfig file to find codegen, because it was moved from
    # pygtk to pygobject. But our pkgfiles point into the cellar and in the
    # pygtk-cellar there is no pygobject.
    inreplace lib/"pkgconfig/pygtk-2.0.pc", "codegendir=${datadir}/pygobject/2.0/codegen", "codegendir=#{HOMEBREW_PREFIX}/share/pygobject/2.0/codegen"
    inreplace bin/"pygtk-codegen-2.0", "exec_prefix=${prefix}", "exec_prefix=#{Formula["pygobject"].opt_prefix}"
  end

  test do
    (testpath/"codegen.def").write("(define-enum asdf)")
    system "#{bin}/pygtk-codegen-2.0", "codegen.def"
  end
end
