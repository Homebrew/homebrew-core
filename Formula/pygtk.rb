class Pygtk < Formula
  desc "GTK+ bindings for Python"
  homepage "http://www.pygtk.org/"
  url "https://download.gnome.org/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2"
  sha256 "cd1c1ea265bd63ff669e92a2d3c2a88eb26bcd9e5363e0f82c896e649f206912"
  revision 2

  bottle do
    cellar :any
    sha256 "6aa04785bcbf9c1e79a268b27263ce61dbfa64cb21023c426b70ead3b6671689" => :mojave
    sha256 "228a919cbba58afc99747e9b5dc6d01013ef8463de2ede5d81c20103afccbb9f" => :high_sierra
    sha256 "fce76d2bf1e1748ac110aede98a622e5f8b737390a3a5e22f56872834b73c033" => :sierra
    sha256 "fd1cef5484267e02971c4daa1eda42e3a66c77786923b0f76b496007282b10a1" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "py2cairo"
  depends_on "pygobject"
  depends_on "libglade" => :optional

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
