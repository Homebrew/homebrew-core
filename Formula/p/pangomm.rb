class Pangomm < Formula
  desc "C++ interface to Pango"
  homepage "https://pango.gnome.org"
  url "https://download.gnome.org/sources/pangomm/2.54/pangomm-2.54.0.tar.xz"
  sha256 "4a5b1fd1b7c47a1af45277ea82b5abeaca8e08fb10a27daa6394cf88d74e7acf"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "cde5d1708cdc2ffcef559a334b4155e9913f40814894004a0f1b3263a4a41f99"
    sha256 cellar: :any, arm64_sonoma:   "96d6b86cb3c3d9b8df92e5a2d9cbf25a0be17d3fbf6575af6a64d6e7cdcab3f8"
    sha256 cellar: :any, arm64_ventura:  "a970a47d003c8802cb36f05742d3ba0040b6711801e593ca124a8e7f5d39c7fe"
    sha256 cellar: :any, arm64_monterey: "27d31ee025f795002d2656cc9bac32d2973f5840c8efccc00999be221d196283"
    sha256 cellar: :any, sonoma:         "6f9ea0544f66fa351dd460b8b93cf1f64c27f5ddf3594dba8071e4dbd6809346"
    sha256 cellar: :any, ventura:        "e86aa89885d5051902f1d63c8282de16d1d5852624d16c4ab4b6f745513b80ea"
    sha256 cellar: :any, monterey:       "711bdbb646de5e52d8214b650cce62755503e79f01c986e50b040265c6f03b1e"
    sha256               x86_64_linux:   "41a65860c91d42df29ae592b9d9c38cf836fbc33d40a99d3e8ce69cb1cebe1e6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

  depends_on "cairomm"
  depends_on "glib"
  depends_on "glibmm"
  depends_on "libsigc++"
  depends_on "pango"

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pangomm.h>
      int main(int argc, char *argv[])
      {
        Pango::FontDescription fd;
        return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs pangomm-2.48").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
