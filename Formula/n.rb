class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v7.5.0.tar.gz"
  sha256 "d4da7ea91f680de0c9b5876e097e2a793e8234fcd0f7ca87a0599b925be087a3"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "92c3adc465225cedba159c9c7218cf441ef47ba373bea23c2d4aba60426e51f8"
    sha256 cellar: :any_skip_relocation, big_sur:       "b981f163cebf4eb714b40491fa218d46cb824cfd50fe5fdffd091a38bdf32977"
    sha256 cellar: :any_skip_relocation, catalina:      "b981f163cebf4eb714b40491fa218d46cb824cfd50fe5fdffd091a38bdf32977"
    sha256 cellar: :any_skip_relocation, mojave:        "b981f163cebf4eb714b40491fa218d46cb824cfd50fe5fdffd091a38bdf32977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92c3adc465225cedba159c9c7218cf441ef47ba373bea23c2d4aba60426e51f8"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
