class Pygtk < Formula
  desc "GTK+ bindings for Python"
  homepage "http://www.pygtk.org/"
  url "https://download.gnome.org/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2"
  sha256 "cd1c1ea265bd63ff669e92a2d3c2a88eb26bcd9e5363e0f82c896e649f206912"
  revision 3

  bottle do
    cellar :any
    rebuild 2
    sha256 "12bab3d76587659b38e56867c9b359941803275716896e2936cd3e8029cf5f3f" => :catalina
    sha256 "87f89d246e3a779381ec2efdee7ee2b69fda464f38a59dd8e14304435d759419" => :mojave
    sha256 "969cef803e110b2767c6d3ade304b92d7f23a02ff7eb4030772b69b52df7c3b2" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "libglade"
  depends_on "py2cairo"
  depends_on "pygobject"

  # Allow building with recent Pango, where some symbols were removed
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/pygtk/2.24.0.diff"
    sha256 "ec480cff20082c41d9015bb7f7fc523c27a2c12a60772b2c55222e4ba0263dde"
  end

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
