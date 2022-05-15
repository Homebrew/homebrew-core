class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.29.tar.gz"
  sha256 "f93e071d4924ab9fd10d5d7a61da802561ecacb42f5daf8079d8b52daa298882"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "291f7605c1f11823fd9a4317c8350707ece09c87167d71dd53f7ba8935d6f012"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bed65edd0b44f94de7f7fe0299c3b70cbc22acfbfda09a9752b730c58e73677e"
    sha256 cellar: :any_skip_relocation, monterey:       "445ea0c4745faf3278d15bc414c9f2ebca52e0a85ac1a77240dc756f867d4ba1"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d7e6b52475fe53384847f0edf270a7387a77fe7a08eb9a39508c79c265e2198"
    sha256 cellar: :any_skip_relocation, catalina:       "2e33a09ab00828ad4cb786d5a9767541b130f002e78ac54915b0b89b6db652f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d99da6b0c7fba792b35f88065e824d163c197fd4369bb1b2e1825ddac464468d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  uses_from_macos "gperf" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
