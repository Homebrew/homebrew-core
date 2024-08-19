class Packetry < Formula
  desc "Fast, intuitive USB 2.0 protocol analysis application for use with Cynthion"
  homepage "https://github.com/greatscottgadgets/packetry"
  url "https://github.com/greatscottgadgets/packetry/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "5dfeb9c711fc10a4225002ee835ae1b8ba8dc6bc6e5fc2d5558412b66f0c716b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "175a54e0ae37d3e5e5a5fa91227f1d4d1df776800cd98b76f6c11a99b967b8e7"
    sha256 cellar: :any,                 arm64_ventura:  "17f42acbf4030b4eb6a902e37af718c53ef7777388f01088d20fe4ec347a13f4"
    sha256 cellar: :any,                 arm64_monterey: "8c4f7070d6358973c5e9fbfd68566bb7ad4312d45e1eaae6e6495fe515d18b9a"
    sha256 cellar: :any,                 sonoma:         "f9f4bc124136e8c0ee69daba42a414ddc5e98a6e45dfe62e445b263f280595bd"
    sha256 cellar: :any,                 ventura:        "9106929c228c332769cb054ebd3728ff9a2132f86214084db9c8bff6a15da616"
    sha256 cellar: :any,                 monterey:       "7924f1b669d8ac376ed015332179ff941cef20035f9700ff6b5f9129d004c906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33ad3be16e8f406980fab4c4b1794baae7a8a6179656b43aebd53348f9928e68"
  end

  depends_on "pkg-config" => :build
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
    assert_match "Test failed: No usable analyzer found", output
  end
end
