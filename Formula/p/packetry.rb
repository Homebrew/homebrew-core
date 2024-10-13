class Packetry < Formula
  desc "Fast, intuitive USB 2.0 protocol analysis application for use with Cynthion"
  homepage "https://github.com/greatscottgadgets/packetry"
  url "https://github.com/greatscottgadgets/packetry/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "8bcbdd8c417cf4694c41e1e6376b95ddea6de9b809e797175dbc993884e5e051"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e3bad187cac9c9294a20a5fa45e6bd3af5a74fb964e590a608194d76715fb165"
    sha256 cellar: :any,                 arm64_sonoma:   "85b8b560660e53195c06ebf5d634db3c4097700a76b6f4d60d2ce460bae43c2f"
    sha256 cellar: :any,                 arm64_ventura:  "44b889a273d48b278e8497d94a89439591577050686bd546665b629792e32ca8"
    sha256 cellar: :any,                 arm64_monterey: "3152e6d5ce557aa33222cf4df9297e01ddd61cea3c02194ce81a34b6f20e828b"
    sha256 cellar: :any,                 sonoma:         "ad6d894f314fc3d35cc1546930be921bf8d16e2a3fb28914da20c89bd63b53e8"
    sha256 cellar: :any,                 ventura:        "73d5241265f1881813102d1099aed521d548c3aba007f118504b486b2d49b2cd"
    sha256 cellar: :any,                 monterey:       "a78ab01bba929557a13357d59f25c504954678cab6c3eba1f42a6613a1d763e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6511f474487ff556debcc9faadedac1236cfea72164c3241f46b5191c548fe12"
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
