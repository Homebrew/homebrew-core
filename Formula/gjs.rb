class Gjs < Formula
  desc "Javascript Bindings for GNOME"
  homepage "https://wiki.gnome.org/Projects/Gjs"
  url "https://download.gnome.org/sources/gjs/1.46/gjs-1.46.0.tar.xz"
  sha256 "2283591fa70785443793e1d7db66071b36052d707075f229baeb468d8dd25ad4"

  bottle do
    sha256 "9d05b437543ea863253eb6ef66b6fa15868f017e460b1af68df361cfcbb14612" => :sierra
    sha256 "882577ffc23585684251d95c40f6599512240dd4c2ea5c612a1c604480854a88" => :el_capitan
    sha256 "c3f17fafb047488c4cc7aada46c89bd1f77745ba327a8f034fc2e13db8ae9353" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "nspr"
  depends_on "readline"
  depends_on "gtk+3" => :recommended

  resource "mozjs24" do
    url "https://ftp.mozilla.org/pub/mozilla.org/js/mozjs-24.2.0.tar.bz2"
    sha256 "e62f3f331ddd90df1e238c09d61a505c516fe9fd8c5c95336611d191d18437d8"
  end

  def install
    resource("mozjs24").stage do
      cd("js/src") do
        # patches taken from MacPorts
        # fixes a problem with Perl 5.22
        inreplace "config/milestone.pl", "if (defined(@TEMPLATE_FILE)) {", "if (@TEMPLATE_FILE) {"
        # use absolute path for install_name, don't assume will be put into an app bundle
        inreplace "config/rules.mk", "@executable_path", "${prefix}/lib"
        system "./configure", "--disable-debug",
                              "--disable-dependency-tracking",
                              "--disable-silent-rules",
                              "--prefix=#{prefix}",
                              "--with-system-nspr",
                              "--enable-readline",
                              "--enable-threadsafe"
        system "make"
        system "make", "install"
        rm Dir["#{bin}/*"]
      end
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
    end
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-dbus-tests",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.js").write <<-EOS.undent
      #!/usr/bin/env gjs
      const GLib = imports.gi.GLib;
    EOS
    system "#{bin}/gjs", "test.js"
  end
end
