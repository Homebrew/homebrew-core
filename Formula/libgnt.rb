class Libgnt < Formula
  desc "NCurses toolkit for creating text-mode graphical user interfaces"
  homepage "https://keep.imfreedom.org/libgnt/libgnt"
  url "https://downloads.sourceforge.net/project/pidgin/libgnt/2.14.3/libgnt-2.14.3.tar.xz"
  sha256 "57f5457f72999d0bb1a139a37f2746ec1b5a02c094f2710a339d8bcea4236123"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://sourceforge.net/projects/pidgin/files/libgnt/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "a9de916fc69770d8bbc6ad92c36950a3d3810d745cb4a8c9b55d7c4cff4a03cd"
    sha256 cellar: :any, arm64_monterey: "5b9638fd113cb8a914c26d16d50865c313c5ce57d57e7afa5e857f6ef576d9c7"
    sha256 cellar: :any, arm64_big_sur:  "a4c4c927df6b0fb2dd4bc6dbf742085eb171c146a448f218448f53e1a21d5015"
    sha256 cellar: :any, ventura:        "62c52f2e13689bf9b1d7dbb7d9323df4334518425276f8cf5858ea6fc00e0fa2"
    sha256 cellar: :any, monterey:       "dcc301110a688e48df0946e77ad07b7112c6bd88fc459b6ae9c6d752b0883c87"
    sha256 cellar: :any, big_sur:        "97d22f2f66bfc361cc88dd7ef38a912c11db9bf77346f20645bec433a3444f38"
    sha256 cellar: :any, catalina:       "ac0543b64dfccaed26f40fd585b9546dede02550afa4063fb76b8f970a2379d8"
    sha256 cellar: :any, mojave:         "b558ad3400f33a9559ace90c2d53e7e578ca674cbae105b2ec620ab277da21cf"
    sha256               x86_64_linux:   "ebff16ba92fadae787c491dae1094706039b2c73a44a1fcacbc2371b031ee647"
  end

  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    # Work around for ERROR: Problem encountered: ncurses could not be found!
    # Issue is build only checks for ncursesw headers under system prefix /usr
    # Upstream issue: https://issues.imfreedom.org/issue/LIBGNT-15
    if OS.linux?
      inreplace "meson.build", "ncurses_sys_prefix = '/usr'",
                               "ncurses_sys_prefix = '#{Formula["ncurses"].opt_prefix}'"
    end

    mkdir "build" do
      system "meson", *std_meson_args, "-Dpython2=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gnt/gnt.h>

      int main() {
          gnt_init();
          gnt_quit();

          return 0;
      }
    EOS

    flags = [
      "-I#{Formula["glib"].opt_include}/glib-2.0",
      "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
      "-I#{include}",
      "-L#{lib}",
      "-L#{Formula["glib"].opt_lib}",
      "-lgnt",
      "-lglib-2.0",
    ]
    system ENV.cc, "test.c", *flags, "-o", "test"
    system "./test"
  end
end
