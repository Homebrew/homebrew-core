class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.2.2/proteinortho-v6.2.2.tar.gz"
  sha256 "15b7c1af0a9d9d226c2cd259777f1ce6508d9294d16ff4f82c73ac5d6df235da"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c73c7536cef24d4895f4dc15f4e294d1516d82eb1ce0a63b92a16bf5ae892e36"
    sha256 cellar: :any,                 arm64_monterey: "8f0c6ea535d05b35e2704dab55ad7ac019da898cb6439f9a55c0097919456e41"
    sha256 cellar: :any,                 arm64_big_sur:  "7f716bcc95ba18ee53e3a31eaeacc2e26cdc5871273ab9c38b2d3d7324c46027"
    sha256 cellar: :any,                 ventura:        "66a55dc52a1eca0344d16999a1ad2712f699d5f32bc9cf1592328a380c8ad87d"
    sha256 cellar: :any,                 monterey:       "7c730c9eca8107733afd450e6e0f3aae106a359f3487f2bb620d884c082560cd"
    sha256 cellar: :any,                 big_sur:        "7545603425c6f7556a3ff866396b6069d7fc82a8c3f5f8b133da2753c3466504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4716efccb013eb246605a3e37c42748d3a65050de6304a062e15588696d710c6"
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
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
