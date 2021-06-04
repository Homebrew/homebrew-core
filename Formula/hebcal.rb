class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.25.tar.gz"
  sha256 "9a7ad6da379bb82784fcf5d32a428aeb220c8475a3e354f6d4879432e698288b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "165966d4a73f5f7dd8170ed0f1f3702329f347620568beddccb9b6bef8061d8c"
    sha256 cellar: :any_skip_relocation, big_sur:       "722a4f86b3d233d7f0b7d3f87f6214de72877a877e2158d0f3957c11da3de86c"
    sha256 cellar: :any_skip_relocation, catalina:      "0228bebcf9cd4be223d4713cb5d1fea3f08d7258dd99359b6cb14c48434e45a2"
    sha256 cellar: :any_skip_relocation, mojave:        "4ab77f6356bc907d484edca88c93d9d715b7959661bfd61263591196778c4b08"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

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
