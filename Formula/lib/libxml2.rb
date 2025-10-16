class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.1.tar.xz"
  sha256 "c008bac08fd5c7b4a87f7b8a71f283fa581d80d80ff8d2efd3b26224c39bc54c"
  license "MIT"

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f495f33976e8977673bc32ca1ec60ba7c95ed58581c7c6381182b6c8359f28a"
    sha256 cellar: :any,                 arm64_sequoia: "9fa7b4af90e8822d5162734e346b2b1d8b1137a40511eb2973005f34ae7d41d0"
    sha256 cellar: :any,                 arm64_sonoma:  "fb526ad2f56800092c03e29061f76c70d9ed56a660f2ee5cd51ab183df68b31e"
    sha256 cellar: :any,                 sonoma:        "dad6d7981c65c4bbfecf02a610c079e1e2e196a456104fb8c6a8e18bad20af7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5a3a4bb21f47e4ce1d60744a2ba0ce73dbe475194c3a7083c946951df23458e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36b22e090190179d28083d080e23e6ff112cc690cc34604ea4f606628888368e"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxml2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => [:build, :test]
  depends_on "icu4c@77"
  depends_on "readline"

  uses_from_macos "zlib"

  def icu4c
    deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
        .to_formula
  end

  def install
    # Work around build failure due to icu4c 75+ adding -std=c11 to installed
    # files when built without manually setting "-std=" in CFLAGS. This causes
    # issues on Linux for `libxml2` as `addrinfo` needs GNU extensions.
    # nanohttp.c:1019:42: error: invalid use of undefined type 'struct addrinfo'
    ENV.append "CFLAGS", "-std=gnu11" if OS.linux?

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--with-history",
                          "--with-http",
                          "--with-icu",
                          "--with-legacy", # https://gitlab.gnome.org/GNOME/libxml2/-/issues/751#note_2157870
                          "--without-lzma",
                          *std_configure_args
    system "make", "install"

    inreplace [bin/"xml2-config", lib/"pkgconfig/libxml-2.0.pc"] do |s|
      s.gsub! prefix, opt_prefix
      s.gsub! icu4c.prefix.realpath, icu4c.opt_prefix, audit_result: false
    end

    # `icu4c` is keg-only, so we need to tell `pkg-config` where to find its
    # modules.
    if OS.mac?
      icu_uc_pc = icu4c.opt_lib/"pkgconfig/icu-uc.pc"
      inreplace lib/"pkgconfig/libxml-2.0.pc",
                /^Requires\.private:(.*)\bicu-uc\b(.*)$/,
                "Requires.private:\\1#{icu_uc_pc}\\2"
    end
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
    ENV.append "PKG_CONFIG_PATH", lib/"pkgconfig"
    args = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libxml-2.0").split
    system ENV.cc, "test.c", "-o", "test", *args
    system "./test"

    # Make sure cellar paths are not baked into these files.
    [bin/"xml2-config", lib/"pkgconfig/libxml-2.0.pc"].each do |file|
      refute_match HOMEBREW_CELLAR.to_s, file.read
    end
  end
end
