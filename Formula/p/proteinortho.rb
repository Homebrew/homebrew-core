class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.3.5/proteinortho-v6.3.5.tar.gz"
  sha256 "1b477657c44eeba304d3ec6d5179733d4c2b3857ad92dcbfe151564790328ce0"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "2356058c1df4e150a263dbfc0f732c7be1d0554c28962d2c3c1bbbff3234470e"
    sha256 cellar: :any,                 arm64_sonoma:  "6563d591255724b9b4d51b183ee88e1896a88947cf27711b98c64b808e788e1d"
    sha256 cellar: :any,                 arm64_ventura: "76bbfd627206c5a346c8b40207cc4c002dbc9a348317032a4eb3dcda98153f46"
    sha256 cellar: :any,                 sonoma:        "9127cb17cb8e363c879b0ecf81c349f61120ef0e0206366defa07ce11e9cb39d"
    sha256 cellar: :any,                 ventura:       "1eeab6b4ab460ca0e684f123b1b6e6a293cd005df2209835530d7d08393ac36f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec96e52a4bea6125ac647b78c022e739b7f1f3bc66f33e3cf19349b8e84134dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bde04add25030aed32aac06465de994ca04e4410181a53deac825858df3df18c"
  end

  depends_on "diamond"
  depends_on "libomp"
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
