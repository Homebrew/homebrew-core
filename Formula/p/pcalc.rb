class Pcalc < Formula
  desc "Calculator for those working with multiple bases, sizes, and close to the bits"
  homepage "https://github.com/alt-romes/programmer-calculator"
  url "https://github.com/alt-romes/programmer-calculator/archive/refs/tags/v3.0.tar.gz"
  sha256 "6ede71e1442710e73edb99eb1742452e67ad5095cad328526633722850aa1136"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3ab7fd9f1bd17b8ae50aaf5c5e419e1ba13214e5362f09b235b834555001ab6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a2b4d667859884ae73bdc1d92bcb74b9cd916f249e72b7ff11c55850caa0f83d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1213e5809a02adfdb8f3d9b37c9fc20f3bdc55f33f165c40205bab09fd118bad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8726e03985b7241593b16d00eafd49b008e479058d3bf984da595c3e4cc2195a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cb160f96c00151800102a58e493b8e394bfdaea743329ca7af245502185bdf5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba2a72db4f367a3ae6dceef1eba8eb5e9ea84586acef55d163d53503a3ffddb1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d42537f4273abcdc5edac493debde8238b833ec7110e6686692ce00128c85661"
    sha256 cellar: :any_skip_relocation, ventura:        "7929c84fa052dc93f47b5dfe37d4332ff916e2c300739b08f721e72bea265a86"
    sha256 cellar: :any_skip_relocation, monterey:       "2259c04f3360d9bb7c26693fe47651972408c21d2b18a7760ecc218d2e2a33ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfef357df427a5d36419bee76ac2a65ce36e191c354d9d773f53b3ed6fd7058f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8d33ee09634262b3a6328d6c1bea82836652fbae7b797f2d507026491d25fd47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bfe8638f58d9b4a6b71c50f08d37b6bf10e773ff1d43946879269cf00df69d4"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "pcalc"
  end

  test do
    assert_equal "Decimal: 0, Hex: 0x0, Operation:  \nDecimal: 3, Hex: 0x3, Operation:",
      shell_output("echo \"0x1+0b1+1\nquit\" | #{bin}/pcalc -n").strip
  end
end
