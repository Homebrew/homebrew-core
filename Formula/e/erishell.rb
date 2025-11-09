class Erishell < Formula
  desc "Encoding for Robust Immutable Storage utility"
  homepage "https://eris.codeberg.page/"
  url "https://codeberg.org/eris/eris-go/archive/v2.0.0.tar.gz"
  sha256 "455f00015b8cd33565a2f18cd8f98010508ff2eb824702be05378904f4d21663"
  license "BSD-3-Clause"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/erishell"
    system "gunzip", "erishell.1.gz"
    man1.install "erishell.1" => "erishell.1"
  end

  test do
    # Split up the string otherwise formatting bureaucrats will reject the formula.
    a = "BIADFUKDPYKJNLGCVSIIDI3FVKND7MO5AGOCXBK2C4ITT5MAL4LSC"
    b = "ZF62B4PDOFQCLLNL7AXXSJFGINUYXVGVTDCQ2V7S7W5S234WFXCJ4"
    assert_equal "urn:eris:#{a}#{b} \n",
      shell_output("#{bin}/erishell discard- buffer- convergent- encode- swap- pop-")
  end
end
