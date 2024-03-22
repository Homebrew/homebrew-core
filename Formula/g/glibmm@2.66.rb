class GlibmmAT266 < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.66/glibmm-2.66.7.tar.xz"
  sha256 "fe02c1e5f5825940d82b56b6ec31a12c06c05c1583cfe62f934d0763e1e542b3"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.gnome.org/sources/glibmm/2.66/"
    regex(/href=.*?glibmm[._-]v?(2\.66(?:\.\d+)+)\.t/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "3915a61ffbfd7ecada46f6e41ac587a41208bb382e5fc23104c52c220e32b17c"
    sha256 cellar: :any, arm64_ventura:  "457126ab74fd61dbfce6499e48a39749e7e3985c5e6b3653ffd711a8eec37b0c"
    sha256 cellar: :any, arm64_monterey: "8c37d94e8e640d1e543aa915915fc1855917423226fc22b81128b5387b9ddb90"
    sha256 cellar: :any, sonoma:         "e614892a5f38beccf279558a374bb3373b61229be5037428ae6f31ea541ffd3f"
    sha256 cellar: :any, ventura:        "d22bd412259f7fba06de7b3a838e0619f640e6733b0117cbc251d6629b0d6827"
    sha256 cellar: :any, monterey:       "3ca011ec8119ee16bc8eaa51f9759495ff70ecdd046916565da0dd6d60b77678"
    sha256               x86_64_linux:   "c771334806ada7e03280cefe916d6435e4805e6c37326ff254eb62d9d0ca60dc"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "libsigc++@2"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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

    flags = shell_output("pkg-config --cflags --libs glibmm-2.4").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
