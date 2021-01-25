class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/12.0/gucharmap-12.0.1.tar.xz"
  sha256 "39de8aad9d7f0af33c29db1a89f645e76dad2fce00d1a0f7c8a689252a2c2155"
  revision 4

  livecheck do
    url :stable
  end

  bottle do
    sha256 "318ada0ffb5e2b9a2c4ed5968f8d38762a4cc2bb7119e50d6bb13354ca1de47f" => :big_sur
    sha256 "f96625e52ea9855f9d4f350e0e61cbc90c352dfd76931dff3fc3503810be0118" => :arm64_big_sur
    sha256 "007a3670270b9b8cbc2e0e9f36cb3854ba987d8b8105ec73e236fc56d28c2cbe" => :catalina
    sha256 "b8f34cbea2db76364e0a4e3a6d2e5ba3110e80ef6b76fa3c165b1ac6b30ee9f1" => :mojave
    sha256 "f8ad1728dd1e0124201e568ad0f69f004245368eb21527dea98ecf045ccad708" => :high_sierra
  end

  depends_on "coreutils" => :build
  depends_on "desktop-file-utils" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "gtk+3"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python#{xy}/site-packages"
    ENV["WGET"] = "curl"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic",
                          "--disable-schemas-compile",
                          "--enable-introspection=no",
                          "--with-unicode-data=download"
    system "make", "WGETFLAGS=--remote-name --remote-time --connect-timeout 30 --retry 8"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gucharmap", "--version"
  end
end
