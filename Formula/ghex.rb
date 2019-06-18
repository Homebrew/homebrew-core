class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/3.18/ghex-3.18.3.tar.xz"
  sha256 "c67450f86f9c09c20768f1af36c11a66faf460ea00fbba628a9089a6804808d3"
  revision 2

  bottle do
    cellar :any
    sha256 "39352f77879498636fdf4608dab0f0be9f20624119708f108ddd60f693f2bb7b" => :mojave
    sha256 "66a8ac3f9fe5e576b37ea8667a2ab648345c27f87cba7d97c2d7587d9120b8c6" => :high_sierra
    sha256 "60134118c841bae367be5977359d19a48d08ec0d7e08286f19631f5c5de38fad" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python#{xy}/site-packages"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-schemas-compile",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/ghex", "--help"
  end
end
