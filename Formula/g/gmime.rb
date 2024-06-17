class Gmime < Formula
  desc "MIME mail utilities"
  homepage "https://github.com/jstedfast/gmime"
  url "https://github.com/jstedfast/gmime/releases/download/3.2.14/gmime-3.2.14.tar.xz"
  sha256 "a5eb3dd675f72e545c8bc1cd12107e4aad2eaec1905eb7b4013cdb1fbe5e2317"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "6e16acb81604f4148018f68bd7cd6f5b490fe32b735bfd0aad835f285bee6f75"
    sha256                               arm64_ventura:  "c50f74db8f74fa8ab213c35cd51a94fef2ad30b6e3902634f4f340296ce8ddd2"
    sha256                               arm64_monterey: "211515061ac24a75022f0efada0fc16e710f6778a5e64c25e5dc3e096fef176b"
    sha256                               sonoma:         "b18779212f120eaf25f631b8c2857fe91e81e0b1c8e227c7b9e0d663ffc4104d"
    sha256                               ventura:        "8471fb1e3f5a8a62151f9f2fd1f55d5b71de0c96e60f3e8a4b70e19063941f5d"
    sha256                               monterey:       "3c69c4fdd87c998407b6ced7771a98ae01c6093b52acf4ecbbaec4fff079716a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "990d4b95f1c247971058b5486e744f5c4ce75e20a33fe4b947f24bc0d9d1090e"
  end

  head do
    url "https://github.com/jstedfast/gmime.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "gpgme"

  def install
    args = %w[
      --enable-largefile
      --disable-vala
      --disable-glibtest
      --enable-crypto
      --enable-introspection
    ]

    system "./autogen.sh" if build.head?

    system "./configure", *std_configure_args, *args
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
    (testpath/"test.c").write <<~EOS
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
    EOS

    flags = shell_output("pkg-config --cflags --libs gmime-#{version.major}.0").strip.split
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"

    # Check that `pkg-config` paths are valid
    cflags = shell_output("pkg-config --cflags gmime-#{version.major}.0").strip
    cflags.split.each do |flag|
      next unless flag.start_with?("-I")

      flag.delete_prefix!("-I")
      assert_path_exists flag
    end

    ldflags = shell_output("pkg-config --libs gmime-#{version.major}.0").strip
    ldflags.split.each do |flag|
      next unless flag.start_with?("-L")

      flag.delete_prefix!("-L")
      assert_path_exists flag
    end
  end
end
