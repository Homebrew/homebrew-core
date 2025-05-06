class Packetry < Formula
  desc "Fast, intuitive USB 2.0 protocol analysis application for use with Cynthion"
  homepage "https://github.com/greatscottgadgets/packetry"
  url "https://github.com/greatscottgadgets/packetry/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "2f2e36500fd29a46bf9043cf3b9a8dde6d14864ac7e6a1782cdce573b81859ee"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "22c49ae08e3854c4719cd38f6946c7a23f937d95f2af9d4f124adb5d85418fdf"
    sha256 cellar: :any,                 arm64_sonoma:  "1522f63e422bbab63675874bdf08cf8696ffd5478eb9c7986928dc5226eae06b"
    sha256 cellar: :any,                 arm64_ventura: "ac33c2598d3ab7e4ba32c23b306510eea957383caddcbd8f9a8d4ec4fde0564e"
    sha256 cellar: :any,                 sonoma:        "08dddc60262a32e355af6a43d70c1eaa0c782d482c61f958891359d672405005"
    sha256 cellar: :any,                 ventura:       "21ddfa4541496350dada1a3ec6361180ae1a70c2d5bf3920cc92c1190437f376"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7f3300e7ef993045cc58515cb726db211888c35a3765c7553f7fed862fb8da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46ab971b2e7e71791bf0e2bfbcbc2a8d89beed2069f3b82b9c096a6f17914273"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "graphene"
    depends_on "harfbuzz"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/packetry --version")

    # Expected result is panic because Cynthion is not connected via USB.
    output = shell_output("#{bin}/packetry --test-cynthion 2>&1", 1)
    assert_match "Test failed: No Cynthion devices found", output
  end
end
