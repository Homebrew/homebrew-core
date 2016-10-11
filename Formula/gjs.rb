class Gjs < Formula
  desc "Javascript Bindings for GNOME"
  homepage "https://wiki.gnome.org/Projects/Gjs"
  url "https://download.gnome.org/sources/gjs/1.46/gjs-1.46.0.tar.xz"
  sha256 "2283591fa70785443793e1d7db66071b36052d707075f229baeb468d8dd25ad4"

  bottle do
    sha256 "9a90cec9628aa4c648a3071eb43e0291c30bee3ad1f53b3907e8358395ef9e80" => :sierra
    sha256 "ef052db92391f3ccd9016f8f90b6b29ac2336884f2334d20e35e74eb9f6f6704" => :el_capitan
    sha256 "0c625e0ea598dcfc143f710de929683cac1aeded17d425b7dba63263a51ba14c" => :yosemite
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
