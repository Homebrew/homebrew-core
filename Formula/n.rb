class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v7.0.0.tar.gz"
  sha256 "2933855140f980fc6d1d6103ea07cd4d915b17dea5e17e43921330ea89978b5b"
  license "MIT"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e5f5c5bda7d49a0cf2c5ec8ff93aa32a37ebae54be832f3ff0a2e79357733c7" => :big_sur
    sha256 "8f2489b60bd94ca9c15f3c5334eee89b73150c02cb42ba0cd6ee9eb100314295" => :arm64_big_sur
    sha256 "02c2c46f1fbe589f28b5ff91ee5605fa951026894b118f977aa01bbd0f34b67d" => :catalina
    sha256 "7b973a504a2bdb3e39e63162d3ab40ee47dac5dd2a49eeb75a7cc2af95c0d38b" => :mojave
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
