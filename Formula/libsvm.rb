class Libsvm < Formula
  desc "Library for support vector machines"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/libsvm/"

  # Upstream deletes old downloads, so we need to mirror it ourselves
  url "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.24.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/libsvm-3.24.tar.gz"
  sha256 "d5881a201a4e6227bf8e2f5de7d6eeaef481c6c2bb9540aeca547737844f8696"

  bottle do
    cellar :any
    sha256 "c2c9525f4cdff0654a5a805dc60aa09880454f0fa5ab92eb1e4c0287cd738c96" => :catalina
    sha256 "75d440e35a774490aea6cec6fd514779069d3ffa55febce89a3f1eb8bad45337" => :mojave
    sha256 "661d867329c2851e84d02e78d2debc78357c9aa0d576223a1011b4d5533a7391" => :high_sierra
    sha256 "e78ffd8fb5a4c430e206462619ef419cde99f48728d09baaf250dc1cbc121abc" => :sierra
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
