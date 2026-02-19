class Gmime < Formula
  desc "MIME mail utilities"
  homepage "https://github.com/jstedfast/gmime"
  url "https://github.com/jstedfast/gmime/releases/download/3.2.15/gmime-3.2.15.tar.xz"
  sha256 "84cd2a481a27970ec39b5c95f72db026722904a2ccf3fdbd57b280cf2d02b5c4"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "e78cfa945f251f0e714eec649d9a2eeff2757f70c01f4e6e3e08a8b9006ca06c"
    sha256                               arm64_sequoia: "b8ac67284de81e8196b96900938780ad0ca73aa0b0411ba2aebddf162b37618c"
    sha256                               arm64_sonoma:  "f19a07ff4fae238eea6a16f5a4f869d19b35fe3ff19fd2314a2f16b4f6ddfc28"
    sha256                               sonoma:        "1cb40b5b061c18e2d6bfe10341787969e239d3bd2f535aac557e21b51cee656e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cf5931215d8318c575fca83eb48ba30e8fddbdd1a9c54f0ebe1bea4df596aef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61032ac4859a9aa36f94a74ae6fe472fa440f4dd5047a88f915a253e5a40a71a"
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

  on_macos do
    depends_on "gettext"
    depends_on "libgpg-error"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
