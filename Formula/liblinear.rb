class Liblinear < Formula
  desc "Library for large linear classification"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/liblinear/"
  url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-2.41.tar.gz"
  sha256 "04b7ccc5124be6833f788b9817a7df0b1679279734e24b24c7a787501a03a43d"
  license "BSD-3-Clause"
  head "https://github.com/cjlin1/liblinear.git"

  bottle do
    cellar :any
    sha256 "7f87690e48b1c1ad17cff21494d81e0c7539c13dcb8e2f90d810e99165ef3013" => :catalina
    sha256 "8c884bdc5cc931e6d4762561518b8b1836785c09fea1cbb034ddd1182519bb62" => :mojave
    sha256 "dd26a959a98b379ce158256166f638b8f5ac23f636052c7a41975c2320b2173f" => :high_sierra
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
