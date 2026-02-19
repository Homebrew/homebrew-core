class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.1.tar.xz"
  sha256 "c008bac08fd5c7b4a87f7b8a71f283fa581d80d80ff8d2efd3b26224c39bc54c"
  license "MIT"
  revision 2

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dcb42a68bf66c5e992a4ff79ca2ef825ae1636f7ed5b30fef442c2535a3f9b9e"
    sha256 cellar: :any,                 arm64_sequoia: "667196feb8df21fb41457431c3289267e5adbf023454cc691bf15aa243f1830e"
    sha256 cellar: :any,                 arm64_sonoma:  "be0013ebd46c95f08569e8f4d96b80830e2e58565e20075f859c18dd76088628"
    sha256 cellar: :any,                 sonoma:        "e0206167a9ed5d3642695623033f991b1750f091c1c84f2c96e63c293f65d338"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a9854a68f030db6f67db31c48b2e823f47f7ce8539d41d602f72ae2804fc755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a3b2e9f3c7397d625f336aa6162211faa8f6592e7670d65b5d3ff76f3744f20"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxml2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => [:build, :test]
  depends_on "readline"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--with-history",
                          "--with-legacy", # https://gitlab.gnome.org/GNOME/libxml2/-/issues/751#note_2157870
                          *std_configure_args
    system "make", "install"

    inreplace [bin/"xml2-config", lib/"pkgconfig/libxml-2.0.pc"], prefix, opt_prefix
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libxml/tree.h>

      int main()
      {
        xmlDocPtr doc = xmlNewDoc(BAD_CAST "1.0");
        xmlNodePtr root_node = xmlNewNode(NULL, BAD_CAST "root");
        xmlDocSetRootElement(doc, root_node);
        xmlFreeDoc(doc);
        return 0;
      }
    C

    # Test build with xml2-config
    args = shell_output("#{bin}/xml2-config --cflags --libs").split
    system ENV.cc, "test.c", "-o", "test", *args
    system "./test"

    # Test build with pkg-config
    ENV.append_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    # TODO: remove following when zlib-ng-compat is linked
    ENV.append_path "PKG_CONFIG_PATH", Formula["zlib-ng-compat"].lib/"pkgconfig" unless OS.mac?
    args = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libxml-2.0").split
    system ENV.cc, "test.c", "-o", "test", *args
    system "./test"

    # Make sure cellar paths are not baked into these files.
    [bin/"xml2-config", lib/"pkgconfig/libxml-2.0.pc"].each do |file|
      refute_match HOMEBREW_CELLAR.to_s, file.read
    end
  end
end
