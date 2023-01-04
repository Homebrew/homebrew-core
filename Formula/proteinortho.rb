class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.1.7/proteinortho-v6.1.7.tar.gz"
  sha256 "4968b1208513e677d5474a6ce081b84e6f0a6dd000975a41273dac51fc02e7d4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "709f0a0e8cfb46bad2b5f961cc3cfc3e0f7accedaa56d2d2e5afb7929a8f4093"
    sha256 cellar: :any,                 arm64_monterey: "1be98247696cd02ccef82e717344de1c71f660db2c45cb844a241af70ebae469"
    sha256 cellar: :any,                 arm64_big_sur:  "8788f84e6bd69759da988fa7d6988bdd3682fe706173ccd1f320d271dce387ce"
    sha256 cellar: :any,                 ventura:        "4b62c7928b74008decf7ce0836ffcf61f5f6549d53b29f65855dbef70453d766"
    sha256 cellar: :any,                 monterey:       "a674f6722c9507cd7648c53e9e4f5221aabfe36643dcd91e7cc6a65cadfa3b3c"
    sha256 cellar: :any,                 big_sur:        "8b97332ab776d0f3c38c5db593ad36b1f88fde442d06d695d2c085db676d9975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d767277c5f300d897dcefc8c5c381aecf5fd58012f981a7a7cfd7fe01d95a22"
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
