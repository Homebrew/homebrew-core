class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://live.gnome.org/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/9.0/gucharmap-9.0.3.tar.xz"
  sha256 "badb002c4d15dca7f3e42b9995ac41dba51490a28709bfefb5a8523fd948f918"

  bottle do
    sha256 "58a9f1ad80737df84402e88890142d94a825c0f8de99998e097c2f720abf48bf" => :sierra
    sha256 "51cb5eda359cd14a06fa25d5b3727aacff670e9db3fcc8a0ca21ddc7fcc8aee4" => :el_capitan
    sha256 "a3793a89b3e82a957b03a742256887f0f796b1febc1b8d48bee031743f1c5f46" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "desktop-file-utils" => :build
  depends_on "wget" => :build
  depends_on "coreutils" => :build
  depends_on "gtk+3"

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic",
                          "--disable-schemas-compile",
                          "--enable-introspection=no",
                          "--with-unicode-data=download"
    system "make"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gucharmap", "--version"
  end
end
