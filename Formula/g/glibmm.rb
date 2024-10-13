class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.82/glibmm-2.82.0.tar.xz"
  sha256 "38684cff317273615c67b8fa9806f16299d51e5506d9b909bae15b589fa99cb6"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "c51a02b0a35290b41affb9625ac4a707b0889cdfd2e82cf1375879012c1d9025"
    sha256 cellar: :any, arm64_sonoma:   "31b6a6d43227bdcbf922bd03dd765ff39817541ecd1324138cacf617fbb73d36"
    sha256 cellar: :any, arm64_ventura:  "2a7e0a5d72958812e3feb2062b4aa7529850734ec4899bebfb2e78f9d185ee32"
    sha256 cellar: :any, arm64_monterey: "f6b90279a5bf2898894ff0846b5d63329387e31ad42a5ff0d82392b630de87da"
    sha256 cellar: :any, sonoma:         "392106bcc37463c4d69ac2bd2351bd07f84d88fc3a4ac183ccc86ccdaa7cb211"
    sha256 cellar: :any, ventura:        "b06828a53ca82f10ccfc9e599a6c9cf25f9bd6cd53015fbfd1a671cc8ad313c2"
    sha256 cellar: :any, monterey:       "565e8660106b4538fa72246f03f2f0a127ccae72a555a39d55c8d7936ca17fd4"
    sha256               x86_64_linux:   "0255438ede1898f8160b8566f377dc033f24a7c1b8eedbf1f6eddd51fdc4958c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "libsigc++"

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", "-Dbuild-examples=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    return unless OS.mac?

    inreplace lib/"glibmm-2.68/proc/gmmproc",
              "#{HOMEBREW_LIBRARY}/Homebrew/shims/mac/super/m4",
              "#{HOMEBREW_PREFIX}/bin/m4"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs glibmm-2.68").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
