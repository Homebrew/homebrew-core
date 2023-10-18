class Gtkmm4 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/4.12/gtkmm-4.12.0.tar.xz"
  sha256 "fbc3e7618123345c0148ef71abb6548d421f52bb224fbda34875b677dc032c92"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "596425991794a30a57081ffe22248749bbe6dd48f2944711af216560c6fc063f"
    sha256 cellar: :any, arm64_ventura:  "37d40a17b893be49e90c6da9a06307b574c7c277401b11594e6185d01ace9dea"
    sha256 cellar: :any, arm64_monterey: "b4453b2142a8fee54c58020fef69a5d7570e9e498c7a5870c0b6defbfca5f051"
    sha256 cellar: :any, arm64_big_sur:  "96663f5e6e435ca299d8b858aa95eabc6369c48ffa4592c78c64e4b1e056aec8"
    sha256 cellar: :any, sonoma:         "f57e57e805c11c78408e37e219f90e7436d8a6d64d30b78d38c059208a1fb446"
    sha256 cellar: :any, ventura:        "05aa2cf79ffe49b870899acc662e1e5bbb274bbea08bfa550667c29dc3f07b6f"
    sha256 cellar: :any, monterey:       "3a05d156e2fa48314d5f325dd39fcca290b6fb43c5d1f185ddff7c05bb30ab12"
    sha256 cellar: :any, big_sur:        "6c6b22194fedb5c8a48e002af931a1b33e0d75037929abb96702c8d9bcba3e51"
    sha256               x86_64_linux:   "bf25d87a1db7d1f3223dbb65924ee3f8dc3cb79a449990cd5e79aa8e599b08db"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "cairomm"
  depends_on "gtk4"
  depends_on "pangomm"

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gtkmm.h>
      class MyLabel : public Gtk::Label {
        MyLabel(Glib::ustring text) : Gtk::Label(text) {}
      };
      int main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtkmm-4.0").strip.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
