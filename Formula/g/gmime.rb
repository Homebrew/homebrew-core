class Gmime < Formula
  desc "MIME mail utilities"
  homepage "https://github.com/jstedfast/gmime"
  url "https://github.com/jstedfast/gmime/releases/download/3.2.15/gmime-3.2.15.tar.xz"
  sha256 "84cd2a481a27970ec39b5c95f72db026722904a2ccf3fdbd57b280cf2d02b5c4"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256                               arm64_tahoe:   "9079c8df9d0e01281591ad2028c853080b9397820bcf0226849837aa2da115ca"
    sha256                               arm64_sequoia: "b88c637274929cbfe432be657a4f9d0ed2a6dcb8573e3289c4634f0719c243bd"
    sha256                               arm64_sonoma:  "1a6299ff6b1f75b3d5cb80d74b2f3a10b844d67de2586cc862084f8c0a55ea49"
    sha256                               arm64_ventura: "e62b5de106b270673a70e3cd743d197136947335d83bae2a832d77ed233841bb"
    sha256                               sonoma:        "f9de52ad7b7be5e2731a2cee8b649fba7095ec305ebc01fb3a47c64f9b68cef5"
    sha256                               ventura:       "d83c620fd9a041b6a8a3bcbed80886e9e95ea20ed5bb70ed4dd5010929fa2210"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27ccd3cf2c9179d022f5d3c8320c56b0e195ba60003666514ecd3827bce3311c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ff3e999c50bbcc7691fac0ba15aa27b1b2d7f99a534032724d6dfc6f3f0fe35"
  end

  head do
    url "https://github.com/jstedfast/gmime.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
  depends_on "gpgme"
  depends_on "libidn2"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "libgpg-error"
  end

  def install
    args = %w[
      --enable-largefile
      --disable-vala
      --disable-glibtest
      --enable-crypto
      --enable-introspection
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Avoid hardcoding Cellar paths of dependencies
    inreplace lib/"pkgconfig/gmime-#{version.major}.0.pc" do |s|
      %w[gpgme libassuan libidn2].each do |f|
        s.gsub! Formula[f].prefix.realpath, Formula[f].opt_prefix
      end
    end

    return if OS.linux?

    # Avoid dependents remembering gmime's Cellar path
    inreplace share/"gir-1.0/GMime-#{version.major}.0.gir", prefix, opt_prefix
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <gmime/gmime.h>
      int main (int argc, char **argv)
      {
        g_mime_init();
        if (gmime_major_version>=3) {
          return 0;
        } else {
          return 1;
        }
      }
    C

    flags = shell_output("pkgconf --cflags --libs gmime-#{version.major}.0").strip.split
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"

    # Check that `pkg-config` paths are valid
    cflags = shell_output("pkgconf --cflags gmime-#{version.major}.0").strip
    cflags.split.each do |flag|
      next unless flag.start_with?("-I")

      flag.delete_prefix!("-I")
      assert_path_exists flag
    end

    ldflags = shell_output("pkgconf --libs gmime-#{version.major}.0").strip
    ldflags.split.each do |flag|
      next unless flag.start_with?("-L")

      flag.delete_prefix!("-L")
      assert_path_exists flag
    end
  end
end
