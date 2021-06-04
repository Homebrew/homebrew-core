class Libsvm < Formula
  desc "Library for support vector machines"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/libsvm/"

  # TODO: Upstream deletes old downloads, so we need a mirror
  url "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.25.tar.gz"
  sha256 "52350e8aa740b176e1d773e9dc08f1340218c37e01bec37ab90db0127e4bb5e5"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/The current release \(Version v?(\d+(?:\.\d+)+)[, )]/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ae3fff4762882360a23280215cafdc93d3da1d598816d34cfb0e7b6a922180e3"
    sha256 cellar: :any, big_sur:       "27481a34d2af64572b48b268c8e47d7700aab4ec9dc2978216c471d512a4cb81"
    sha256 cellar: :any, catalina:      "ad8d34d17fdca6b25374eff11b5f2b1067d19894358b23c04b3b8ac0f82180b1"
    sha256 cellar: :any, mojave:        "485eec232bd3cc0619494de50cac4ef4a5b65761d5d6a062c62e07d9a0007e31"
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
