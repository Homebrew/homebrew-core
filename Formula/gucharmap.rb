class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://live.gnome.org/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/9.0/gucharmap-9.0.1.tar.xz"
  sha256 "8617ab68f2977cc3780a1f39264a48b8d9cf8824172c442fa9ca1c11d81dbd6c"

  bottle do
    sha256 "6bf89a57386e26c7ee217291e124ab4bf0e0c83f068f307d569bd23735788aa2" => :sierra
    sha256 "06abacb72154449f80feb8dae2521c3fdd47259d522601bd89b388da6cf49242" => :el_capitan
    sha256 "6bf708291779f24d1629d5aa7b19b09f901c62b316bfc0752e6b4aec4e560b87" => :yosemite
    sha256 "c5676b389e475bc90073eb0534dc0687f4056b0c83a40fd877d61e4b36346a81" => :mavericks
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
