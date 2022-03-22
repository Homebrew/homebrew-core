class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/12.0/gucharmap-12.0.1.tar.xz"
  sha256 "39de8aad9d7f0af33c29db1a89f645e76dad2fce00d1a0f7c8a689252a2c2155"
  revision 4

  bottle do
    sha256 arm64_monterey: "04be31ca892b6d00aabe5025063abb525630883ff1dd1a99f4f6fc1e8de48802"
    sha256 arm64_big_sur:  "f96625e52ea9855f9d4f350e0e61cbc90c352dfd76931dff3fc3503810be0118"
    sha256 monterey:       "739f55d1ebe5cb2bbd1cb3e414c9e0e01f6f7d2172aa2cb858e016340da875ea"
    sha256 big_sur:        "318ada0ffb5e2b9a2c4ed5968f8d38762a4cc2bb7119e50d6bb13354ca1de47f"
    sha256 catalina:       "007a3670270b9b8cbc2e0e9f36cb3854ba987d8b8105ec73e236fc56d28c2cbe"
    sha256 mojave:         "b8f34cbea2db76364e0a4e3a6d2e5ba3110e80ef6b76fa3c165b1ac6b30ee9f1"
    sha256 high_sierra:    "f8ad1728dd1e0124201e568ad0f69f004245368eb21527dea98ecf045ccad708"
    sha256 x86_64_linux:   "6604c5046dbae96f07f30c6e4ee45c9b2e6e5a1030ae44c5dcd03870361c8fc4"
  end

  depends_on "coreutils" => :build
  depends_on "desktop-file-utils" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "gtk+3"

  uses_from_macos "perl" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python#{xy}/site-packages"
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?
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
