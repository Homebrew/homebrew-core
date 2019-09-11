class Pygtk < Formula
  desc "GTK+ bindings for Python"
  homepage "http://www.pygtk.org/"
  url "https://download.gnome.org/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2"
  sha256 "cd1c1ea265bd63ff669e92a2d3c2a88eb26bcd9e5363e0f82c896e649f206912"
  revision 3

  bottle do
    cellar :any
    sha256 "4b7adc63c58467d417789307672f8e269bda9189e893e3962547dbcde0e3c52e" => :mojave
    sha256 "e999cf9dbfe2cbed2aa8106acfa5e7a357c421146c1ae4b8de7d47e9b87b72a4" => :high_sierra
    sha256 "73871fa751d38f41bf54d09531764ed05c2a3f8a5b8dfd54f34c26a7638965b2" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "py2cairo"
  depends_on "pygobject"

  def install
    ENV.append "CFLAGS", "-ObjC"
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
