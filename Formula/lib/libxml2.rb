class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.4.tar.xz"
  sha256 "98087fd181d9070724f3fbc65c7377db03038eb92bd882374daff44940138821"
  license "MIT"
  compatibility_version 1

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c7bef74ab590bd606b11bc9b3da6234a5fb0564313ea762be3707ccb05b6a219"
    sha256 cellar: :any, arm64_tahoe:       "5fb19b06755d9ed1aedd83ed3c3450efc6a8c248265670f00c0b7e02b8b69f64"
    sha256 cellar: :any, arm64_sequoia:     "c527df2ccbb8e3603718b7cfc318fc8907ebbc898813832ee5cdaef3c953401a"
    sha256 cellar: :any, arm64_sonoma:      "94cee1905a126e6eccf3505e0e7cf76c6743c40d26cf237f5f7baf420125d16f"
    sha256 cellar: :any, arm64_linux:       "71fa82e82833c9ad18e166890efd226bb52494c62bb67f69155a068783d1d870"
    sha256 cellar: :any, x86_64_linux:      "57b219c3bbf96111a57e2afaa052757b8697f268bc61944689eb9ae35829f1d0"
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
    args = shell_output("#{formula_opt_bin("pkgconf")}/pkgconf --cflags --libs libxml-2.0").split
    system ENV.cc, "test.c", "-o", "test", *args
    system "./test"

    # Make sure cellar paths are not baked into these files.
    [bin/"xml2-config", lib/"pkgconfig/libxml-2.0.pc"].each do |file|
      refute_match HOMEBREW_CELLAR.to_s, file.read
    end
  end
end
