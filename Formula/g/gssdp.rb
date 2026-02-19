class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.6/gssdp-1.6.4.tar.xz"
  sha256 "ff97fdfb7f561d3e6813b4f6a2145259e7c2eff43cc0e63f3fd031d0b6266032"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "757813a4572ec251ec2b0b5d08fac402448d7eb07e798f4ddae34beafb4dd786"
    sha256 cellar: :any, arm64_sequoia: "ebe88f533fe10a5c8bcd40124a1eba3be1fb2d7b1f519b8d52c8e5d72de9a252"
    sha256 cellar: :any, arm64_sonoma:  "583257d286536b6fbb04901b527beeb0782578c667e13cf9fa943bb59bde6a36"
    sha256 cellar: :any, arm64_ventura: "259745694e0f5e9ec0cf3590c2e2e7cfb5ef85a606be7b5399a0e5af5cbaff47"
    sha256 cellar: :any, sonoma:        "bc05bf33af411e1488903ff6cd774eef71232b4ac8da91bbcab9089ccbef0c16"
    sha256 cellar: :any, ventura:       "e2a98e88c932592c7dc25135c1d142159531c5c247621eae87d01ddaefe9b1e4"
    sha256               arm64_linux:   "30d8f9d8c169ad2f144275e2d20a6594aed7532e8050f236dd0ccf208e6a1392"
    sha256               x86_64_linux:  "912c3889c750253f08a991711db1d2cf6cfa44e99933d733c7441d42665251c3"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libsoup"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"

    system "meson", "setup", "build", "-Dsniffer=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libgssdp/gssdp.h>

      int main(int argc, char *argv[]) {
        GType type = gssdp_client_get_type();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gssdp-1.6").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
