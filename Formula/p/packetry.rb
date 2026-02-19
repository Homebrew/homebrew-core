class Packetry < Formula
  desc "Fast, intuitive USB 2.0 protocol analysis application for use with Cynthion"
  homepage "https://github.com/greatscottgadgets/packetry"
  url "https://github.com/greatscottgadgets/packetry/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "158cd25536c6d4feab2b9e76fcbb4174fdb2fd6fb1c309775a3b2efbe84db33b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b44a327337008bac85d41e08c6c01d443ec193d25671791275bb846fbb49a98"
    sha256 cellar: :any,                 arm64_sequoia: "96b22357843f520ea804060b1a2016ca1597d2944bd9ba421ee18cb4400aed5f"
    sha256 cellar: :any,                 arm64_sonoma:  "8e922696b8fe099ee251474983e678d5dca2a66fd51f9e9ca0655f44c57828bf"
    sha256 cellar: :any,                 sonoma:        "4cbed67c2f94db98371ffd4e1c22339461ced6aefcb3e1aed5aa780088a587df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2069f0fd40e8bb856ffa695b73c5d446b2f4f334413ecc63a1412e185160d162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feb64fb888f5d3e9769b784226363100a57f2b81ff3ede2c8ebceec074d72d8c"
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
