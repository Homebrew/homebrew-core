class Gmime < Formula
  desc "MIME mail utilities"
  homepage "https://github.com/jstedfast/gmime"
  url "https://github.com/jstedfast/gmime/releases/download/3.2.15/gmime-3.2.15.tar.xz"
  sha256 "84cd2a481a27970ec39b5c95f72db026722904a2ccf3fdbd57b280cf2d02b5c4"
  license "LGPL-2.1-or-later"

  bottle do
    sha256                               arm64_sequoia:  "458bcb6ae4fd091fd35b48f9917ff52d2f38254a480164416b682049ae9d083b"
    sha256                               arm64_sonoma:   "a509468f057fc0a2013788381d8884710ef74d5241b706891372a43a9aa402ba"
    sha256                               arm64_ventura:  "ea7b8ca1f448ab1fa9486e3e55a12305f2df3b5a8c19b99587332d0412326cf3"
    sha256                               arm64_monterey: "c7c87673c6db12e288f836fe8a7aad8312c3aba2d35dae680a155741a82f660c"
    sha256                               sonoma:         "103a9dada388b0c0d1e00f5d43e89a69be9c811c5db9053410aab1349897288a"
    sha256                               ventura:        "4e6bcbb52d75e42ecd622a6aa76f376c148421aa073b1a808e82392cdb3f3b75"
    sha256                               monterey:       "2acb6d3050ee79911c9f1407c90b1f0870becf0f4540ad441dc4f5cab69e5fc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7c75bc8dc1096a6e9d433bd65ef5e5781202ab0f62b8bb3d886e7cf398545d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d427feebdf23d147fb3b4bf6d0df1b35d08c20d71d5d2100ab3572c2edb982d6"
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
