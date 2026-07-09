class GlibmmAT266 < Formula
  desc "C++ interface to glib"
  homepage "https://gtkmm.gnome.org/"
  url "https://download.gnome.org/sources/glibmm/2.66/glibmm-2.66.9.tar.xz"
  sha256 "5a026e5602085307c7dcb72b71b07261c40f80914277bef5f8d7f2ecab739bec"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.gnome.org/sources/glibmm/2.66/"
    regex(/href=.*?glibmm[._-]v?(2\.66(?:\.\d+)+)\.t/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0dddfce8c9884ff8d1b4ebf7c9ec9a1176db31a653a17b01b53f0751e9d2ceb0"
    sha256 cellar: :any, arm64_sequoia: "125c14df7e21522d602151d36567eb45364297cf4fc3b6d895e4da72f5b05c44"
    sha256 cellar: :any, arm64_sonoma:  "e7e271b5a10e31e76962c268afe38d379d34e4cdd2123e2f18020fd1ec89ceb0"
    sha256 cellar: :any, sonoma:        "07215c72613f10a96dd0f65d40926d71572f998930ce054a9ff6c1e1050ce851"
    sha256               arm64_linux:   "9294ce1ab6164e78f6d84714685ca14ef0ed814ae4c6cbeb07c4ec829be40d58"
    sha256               x86_64_linux:  "e2cc56e6739ebd052dec42688582d356c78f5680f1ae73da40c10375f06195bb"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
  depends_on "libsigc++@2"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs glibmm-2.4").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
