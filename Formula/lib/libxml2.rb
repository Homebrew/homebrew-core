class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.2.tar.xz"
  sha256 "c8b9bc81f8b590c33af8cc6c336dbff2f53409973588a351c95f1c621b13d09d"
  license "MIT"

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21b0d9f78c4c85fc6e8ba934d2dcbd840f80777ec6e4b3272409db51ed67b0a6"
    sha256 cellar: :any,                 arm64_sequoia: "709ecf6c22956f9e3652197f5fb4d29d05e0883981bb47915ac693be9497b6f3"
    sha256 cellar: :any,                 arm64_sonoma:  "3a174f412cf8a3330503929a849710ffc39fbc9d284bf01564ac4bfe92d6d800"
    sha256 cellar: :any,                 sonoma:        "62a71bec0d44fc1e749bd6057daf421c841ab0b3ab2579ddda62558a3bc2a4a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7d519b032ee340ad605d0ce1f72d6dbfe1402f6f68ac70bcb4d539e73352110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17b63e416112ab39a3cd942961dcd1deebf771a7709eac0b10285356e70ee500"
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
    args = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libxml-2.0").split
    system ENV.cc, "test.c", "-o", "test", *args
    system "./test"

    # Make sure cellar paths are not baked into these files.
    [bin/"xml2-config", lib/"pkgconfig/libxml-2.0.pc"].each do |file|
      refute_match HOMEBREW_CELLAR.to_s, file.read
    end
  end
end
