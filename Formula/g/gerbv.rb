class Gerbv < Formula
  desc "Gerber (RS-274X) viewer"
  homepage "https://gerbv.github.io/"
  url "https://github.com/gerbv/gerbv/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "3eef8eb8a2755da8400e7a4394229475ad4cf1a2f85345720ee1da135a1aec44"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "16ddd7d1212886648901aef5bd32548cda6180e8ea9ac2bd0092733453b20947"
    sha256 arm64_sequoia:  "2cec6e703cf8900a47542fbbf627d938289b09b1344dd25c7a1f4920c5210d50"
    sha256 arm64_sonoma:   "f0033cf40029771a108a543761225a8cf7f76a93978c64d5fe06b77e1d212ecf"
    sha256 arm64_ventura:  "78372c7e31bacbc5f95a5741ccdbd2a2c1c45709c63cf1dda4df2e1e11e9df79"
    sha256 arm64_monterey: "6b6149199423babe20ed89d917bde3217a1fde6064e58670ffd2b9bc9ea437bc"
    sha256 sonoma:         "7f898d7cad1631c74609ef044011c7e16e7bf667e0d63af22b511ca31daa6f26"
    sha256 ventura:        "0ad6231d51238f613960b2fa1344c0be1ce317a91464fd81295a882788b5157c"
    sha256 monterey:       "01753a1244ff7d7a2c783aa1b1acb0dfe76b420b68b872fa8ef339885596d343"
    sha256 arm64_linux:    "b76c77dcb774a0990ba2b2d549df16254250b47d3173a0cfb6ec595a4257df24"
    sha256 x86_64_linux:   "581743d09f59d3e816c5f7f903e26d82eb53065b0cbbed29685f94967c96a641"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+" # GTK3/GTK4 issue: https://github.com/gerbv/gerbv/issues/71

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  def install
    ENV.append "CPPFLAGS", "-DQUARTZ" if OS.mac?
    inreplace "autogen.sh", "libtool", "glibtool"

    # Disable commit reference in include dir
    inreplace "utils/git-version-gen.sh" do |s|
      s.gsub! 'RELEASE_COMMIT=`"${GIT}" rev-parse HEAD`', "RELEASE_COMMIT=\"\""
      s.gsub! "${PREFIX}~", "${PREFIX}"
    end
    system "./autogen.sh"
    system "./configure", "--disable-update-desktop-database",
                          "--disable-schemas-compile",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    # executable (GUI) test
    system bin/"gerbv", "--version"
    # API test
    (testpath/"test.c").write <<~C
      #include <gerbv.h>

      int main(int argc, char *argv[]) {
        double d = gerbv_get_tool_diameter(2);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libgerbv").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
