class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.80/glibmm-2.80.0.tar.xz"
  sha256 "539b0a29e15a96676c4f0594541250566c5ca44da5d4d87a3732fa2d07909e4a"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "874cd180abccbe1e4637ba6459ee2c4aa60b65adc240387ae6aa3a47ac040e11"
    sha256 cellar: :any, arm64_ventura:  "eb5880ccddc02dd49653b67767b06d9aa6748e2895ebf6a7adcff17651063a2a"
    sha256 cellar: :any, arm64_monterey: "0a8b3f36488bd9bda5ea87ef2123e905321212397c690c1c21f26b19e47496a1"
    sha256 cellar: :any, sonoma:         "318957fb8c9cc96ed11a7df991c065dfb0b3409a3f3363addbac27ec12ee290b"
    sha256 cellar: :any, ventura:        "94875f1cf28156ff0fd0a5b71ba8282ac62ac146db0e69c943246f8df2f15d0f"
    sha256 cellar: :any, monterey:       "65cc335fd272f9dc8f3cc40d6ab66de7a7220a6a5a370474356025b18b7b4e52"
    sha256               x86_64_linux:   "10ff3f89ee53bcd2daaee31764896d968e9292ba7cdd46cde031c658fed1b2dc"
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
