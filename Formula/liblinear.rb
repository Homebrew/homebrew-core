class Liblinear < Formula
  desc "Library for large linear classification"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/liblinear/"
  url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-2.46.tar.gz"
  sha256 "616dd3a9b5596894de427f141a4902fa99dafc51ff9d18e8d723852fdc0cb53b"
  license "BSD-3-Clause"
  head "https://github.com/cjlin1/liblinear.git", branch: "master"

  livecheck do
    url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/"
    regex(/href=.*?liblinear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7e7cab0aae3e2aa39079c8b62c74a515b738a15b5ba0c6f5090346c9224fd7ef"
    sha256 cellar: :any,                 arm64_monterey: "6dcd9d27db4bf48c077b27ed7f1c5efa575e3e0fef9ff792f6c297d656d8d7b1"
    sha256 cellar: :any,                 arm64_big_sur:  "3c38a1dd2728cb81095949356e80bbe83841481a98edd82e8f022af7a4453bbd"
    sha256 cellar: :any,                 ventura:        "073bc33c6fd64e2197935c997ae97975465a4bbc5735d122a6db7ba4c0c8fd2a"
    sha256 cellar: :any,                 monterey:       "0b9b05f1c1e6fdec4ff041da4c41cc7825e11d5196195de54ba56a4a71928fcc"
    sha256 cellar: :any,                 big_sur:        "f4e750007ca329df9d194d2dd398e0a9d6ef0557feb5c60de6969a9be6801cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8000191b904633c5b0cc17de5a9737be048a3cb6764a08aa4270300eb8369fc3"
  end

  # Fix sonames
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/bac35ae9140405dec00f1f700d2ecc27cf82526b/liblinear/patch-Makefile.diff"
    sha256 "11a47747918f665d219b108fac073c626779555b5022903c9b240a4c29bbc2a0"
  end

  def install
    soversion_regex = /^SHVER = (\d+)$/
    soversion = (buildpath/"Makefile").read
                                      .lines
                                      .grep(soversion_regex)
                                      .first[soversion_regex, 1]
    system "make", "all"
    bin.install "predict", "train"
    lib.install shared_library("liblinear", soversion)
    lib.install_symlink shared_library("liblinear", soversion) => shared_library("liblinear")
    include.install "linear.h"
  end

  test do
    (testpath/"train_classification.txt").write <<~EOS
      +1 201:1.2 3148:1.8 3983:1 4882:1
      -1 874:0.3 3652:1.1 3963:1 6179:1
      +1 1168:1.2 3318:1.2 3938:1.8 4481:1
      +1 350:1 3082:1.5 3965:1 6122:0.2
      -1 99:1 3057:1 3957:1 5838:0.3
    EOS

    system "#{bin}/train", "train_classification.txt"
  end
end
