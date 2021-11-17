class Pcalc < Formula
  desc "Calculator for those working with multiple bases, sizes, and close to the bits"
  homepage "https://github.com/alt-romes/programmer-calculator"
  url "https://github.com/alt-romes/programmer-calculator/archive/v2.2.tar.gz"
  sha256 "d76c1d641cdb7d0b68dd30d4ef96d6ccf16cad886b01b4464bdbf3a2fa976172"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "799c6f87ae31666765e9bf3b08553b5d51e9b76c54208e679e0f03ee94250f1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fab09fa817c8bff8e571344a16b1c6be62c76fb21afc4db76617b6c1fc4b15f0"
    sha256 cellar: :any_skip_relocation, monterey:       "71efc7e3060ea9a4fc3e5a9e9e519d72bb51de179302f1d815de0f7994f169b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "78d3f7309704b06f355e6712f1d2e4062bf5aff75aa84dbc740e27fe54c37467"
    sha256 cellar: :any_skip_relocation, catalina:       "582fae9a802ad376f792180263277acb57a63167980156bb68f1689bf923e033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a09f8b238d357411b0742611e924758e9d204c80b5b9178b618034bc1ebf00e1"
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
