class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.38/atk-2.38.0.tar.xz"
  sha256 "ac4de2a4ef4bd5665052952fe169657e65e895c5057dffb3c2a810f6191a0c36"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "d6f1e98a0e62df404790a1e52f1729f54c949e74223658cde7a206c4a17a3e6c"
    sha256 cellar: :any, arm64_ventura:  "8da3539576393ec7998816f209eeb3fc0b681264ffe722613de22258562b2d44"
    sha256 cellar: :any, arm64_monterey: "078fba0fd9c27175313b3232fdf2fe36e72a19e1efdef97a3c622d23869313c4"
    sha256 cellar: :any, arm64_big_sur:  "97a4d14824805cdd1c6b9bdee415e3420bfd54beab814d343648395fcc684f69"
    sha256 cellar: :any, sonoma:         "40db70252e2688ce862b4520aa7e87884e8604aa3554b3ffc0728f2dc207ce85"
    sha256 cellar: :any, ventura:        "cf252eac8fce14498f6ded793c6f650329872992e090fe6b45861388854ab452"
    sha256 cellar: :any, monterey:       "faca1ff938b34b23e284321d8037673f270030aae0c7ea8b44f8a4088c8e9ab5"
    sha256 cellar: :any, big_sur:        "254605e7c9a5f95f7e1aaec2d58e60c8cdaf4fde910e92a0a032938cb98efc57"
    sha256 cellar: :any, catalina:       "048076e890b1b184892bd58f1059f701a1665ac378f5e1431ae681210ae28b0c"
    sha256               x86_64_linux:   "4ffb42482b22fe9150193395fc3fc0a41d1f92e3a8c0aa7e9dd17aaef8ff6f7c"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <atk/atk.h>

      int main(int argc, char *argv[]) {
        const gchar *version = atk_get_version();
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs atk").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
