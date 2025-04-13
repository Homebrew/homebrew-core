class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.3.5/proteinortho-v6.3.5.tar.gz"
  sha256 "1b477657c44eeba304d3ec6d5179733d4c2b3857ad92dcbfe151564790328ce0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "691114c22c7b2da4e5f32b9899793f87bf1288b116907a838328c3ba9665ccf2"
    sha256 cellar: :any,                 arm64_sonoma:  "4b31f93f3664b884ca7d1e75cec1443eaec3176cdd378d2d097b3df442fc846d"
    sha256 cellar: :any,                 arm64_ventura: "6bb3b85a66eb9f7b274c5da08d9e521d9049e2e362cf810d526a026d4e2c7a7f"
    sha256 cellar: :any,                 sonoma:        "ab241ce26173fedd1e3e705355bb1ad5cfd011c4ffa91f878ee3b413ac551c25"
    sha256 cellar: :any,                 ventura:       "17a1cf8b7f0266b63fecf18342dad5276dcac2d153937b194a2b343a1cb0e0a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f26d43b6f2913fb05d1309e6bbeacd1d86ea69da151565cf148a69c096d6be96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f34a42b6359383dcf6040c2445f76bb662dc36e0585ac6d1709c7f83f20f755"
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    ENV.cxx11

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system bin/"proteinortho", "-test"
    system bin/"proteinortho_clustering", "-test"
  end
end
