class Liblinear < Formula
  desc "Library for large linear classification"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/liblinear/"
  url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-2.42.tar.gz"
  sha256 "cf44f13809f506be10c8434fdbf4d4f7a3c6f8da9e93b6e03fb8a80a8e9c938d"
  license "BSD-3-Clause"
  head "https://github.com/cjlin1/liblinear.git"

  livecheck do
    url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/"
    regex(/href=.*?liblinear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "6afbe67a6cb651a0ac829b421c2a4e7f875b7eb41ceb7a8acfe24c8be2203114" => :big_sur
    sha256 "3d10c6424ded069cf0642018690d5e87725ca7ad6ca0b762e00446c6d05718b9" => :arm64_big_sur
    sha256 "b1ff692bb0430cc95e14ef736a8b1730afa826887648f91835869181922a2136" => :catalina
    sha256 "9481d9d47bea60aff197812d668bb3fef9702e1922da016bc5c6d8bde7f32c08" => :mojave
    sha256 "0ed1af625144027e73642a9b2eff35593a086692ef1abea5af6ab85ab3869abd" => :high_sierra
  end

  # Fix sonames
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b1dbde5b1d7c/liblinear/patch-Makefile.diff"
    sha256 "b7cd43329264ed0568f27e305841aa24817dccc71e5ff3c384eef9ac6aa6620a"
  end

  def install
    system "make", "all"
    bin.install "predict", "train"
    lib.install "liblinear.dylib"
    lib.install_symlink "liblinear.dylib" => "liblinear.1.dylib"
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
