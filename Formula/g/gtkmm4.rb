class Gtkmm4 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/4.14/gtkmm-4.14.0.tar.xz"
  sha256 "9350a0444b744ca3dc69586ebd1b6707520922b6d9f4f232103ce603a271ecda"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c55a06b8ebfaa06fbf7fe1bb09cedf0455227a5498a00e91d6773df060b0a1d7"
    sha256 cellar: :any, arm64_ventura:  "19664060e0042bdf984de2dc37b6c2c0c75344175f7527e52d9d2f0c84d837c2"
    sha256 cellar: :any, arm64_monterey: "6a95cc432eca070c92a634ef4d5cee579b80b23709130fd99757690349cd3982"
    sha256 cellar: :any, sonoma:         "9cf415687585c274043504edec27506c24345f7205c65c6bf8bc2a5d173d0829"
    sha256 cellar: :any, ventura:        "850cb725cfa0854957d1892a2d0b3da4ad5333ff4a065feb959cac78a6c5875f"
    sha256 cellar: :any, monterey:       "e975015a9cc15fea0f3b9365458869841b4498840cc1a61d248653483765750c"
    sha256               x86_64_linux:   "96c1cfa59f83f8a91af058e5fcc1b5f888875718ae2974b4ec512918919a91ee"
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
