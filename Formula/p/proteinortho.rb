class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.3.2/proteinortho-v6.3.2.tar.gz"
  sha256 "3b3c58e814ca10f77a25954b0bcddc479b9f61682f3dc5c93d85b07f109342a4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6eb6089f3e60e2136f11ea8997536fd76ae83d94455c23ad88f439a0a47397c3"
    sha256 cellar: :any,                 arm64_sonoma:   "a3966fa66db6edea9c7b12fb65213bec1e6641860b6d05ff28b74b7af9e13996"
    sha256 cellar: :any,                 arm64_ventura:  "0edd33e29ad7d95644c83f9412329ce80356424ce61ee89c84004f6d746653d8"
    sha256 cellar: :any,                 arm64_monterey: "b4b9d0a86d9e83e902f506ddd48633134727d9a0caacb03bb52751edf3e1084b"
    sha256 cellar: :any,                 sonoma:         "b0adc4eba6090113da1c04f1ae1345e9527af6c9c7492b3eb567478aa12556d0"
    sha256 cellar: :any,                 ventura:        "aa9c68bbc76c78b280c5c41df428f0113ee594f26201baaca97566c13fde2952"
    sha256 cellar: :any,                 monterey:       "8f6e2d323da560d09c8a40938f497bf6f4059def847c16b53d3d87311a6c9ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e889a7d294a99c804f564e08afb6feef66c20098867405c063681c78fd50772"
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
