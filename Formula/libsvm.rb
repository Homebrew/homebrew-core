class Libsvm < Formula
  desc "Library for support vector machines"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/libsvm/"

  # Upstream deletes old downloads, so we need to mirror it ourselves
  url "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.24.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/libsvm-3.24.tar.gz"
  sha256 "d5881a201a4e6227bf8e2f5de7d6eeaef481c6c2bb9540aeca547737844f8696"

  bottle do
    cellar :any
    sha256 "8dded17ad2e22342ae25d392d5e4d9776572f8b5081e62064e97c027f8c481e6" => :catalina
    sha256 "4db9a3e77edfda475ca8bdcad82ce1443ed50df41b28b59d726b1fa81944e2c7" => :mojave
    sha256 "5d4ee9cec3a0048ef8abd328022fa3752c3dc2ead9d86d9995b79558700dbbd2" => :high_sierra
  end

  def install
    system "make", "CFLAGS=#{ENV.cflags}"
    system "make", "lib"
    bin.install "svm-scale", "svm-train", "svm-predict"
    lib.install "libsvm.so.2" => "libsvm.2.dylib"
    lib.install_symlink "libsvm.2.dylib" => "libsvm.dylib"
    MachO::Tools.change_dylib_id("#{lib}/libsvm.2.dylib", "#{lib}/libsvm.2.dylib")
    include.install "svm.h"
  end

  test do
    (testpath/"train_classification.txt").write <<~EOS
      +1 201:1.2 3148:1.8 3983:1 4882:1
      -1 874:0.3 3652:1.1 3963:1 6179:1
      +1 1168:1.2 3318:1.2 3938:1.8 4481:1
      +1 350:1 3082:1.5 3965:1 6122:0.2
      -1 99:1 3057:1 3957:1 5838:0.3
    EOS

    (testpath/"train_regression.txt").write <<~EOS
      0.23 201:1.2 3148:1.8 3983:1 4882:1
      0.33 874:0.3 3652:1.1 3963:1 6179:1
      -0.12 1168:1.2 3318:1.2 3938:1.8 4481:1
    EOS

    system "#{bin}/svm-train", "-s", "0", "train_classification.txt"
    system "#{bin}/svm-train", "-s", "3", "train_regression.txt"
  end
end
