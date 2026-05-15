class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.3.tar.xz"
  sha256 "78262a6e7ac170d6528ebfe2efccdf220191a5af6a6cd61ea4a9a9a5042c7a07"
  license "MIT"
  compatibility_version 1

  # We use a common regex because libxml2 doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libxml2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fa797509d0bd7d73b1c296bb696d544a6c5e212f1a196d867aba7e53d0d6c6b4"
    sha256 cellar: :any,                 arm64_sequoia: "cf956a7b12be9755ac1a905470c35ad070c7a4fa52a13b380c66eae3dcccf353"
    sha256 cellar: :any,                 arm64_sonoma:  "e8105aa3d75882944ac86f34a3feec34075ec774c58f1d30848e1f6addc2499a"
    sha256 cellar: :any,                 sonoma:        "c39f8567f5d228ab173ab8c467b65cae0b85f7da07d8cd8984597d5e3caeafd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a2523b36bbc7cff373c7325d5cba58c53d94bebfcac43d7a570ec84dfe4f4c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a76858b74071c78ad6f70ccdcb29563944d18da9350504c4d95bed17279593d1"
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
