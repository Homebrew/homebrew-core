class Libsvm < Formula
  desc "Library for support vector machines"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/libsvm/"

  # Upstream deletes old downloads, so we need to mirror it ourselves
  url "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.23.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/libsvm-3.23.tar.gz"
  sha256 "257aed630dc0a0163e12cb2a80aea9c7dc988e55f28d69c945a38b9433c0ea4a"

  bottle do
    cellar :any
    sha256 "3fba9f6c0ce647a202c653b1f024d7dd53174aecbb4082b9333a1122309b36af" => :mojave
    sha256 "6fae589e624777638a8a5bc1c8b03e3bb48f88a61380b608273b44bd2d25aec4" => :high_sierra
    sha256 "39f3552e425be4bcb6e42d917b508bf94904520526c49ec52712c017680583fd" => :sierra
    sha256 "67867d2ddde33efd85da4c1a03757af0e3dcf591186552140876ddd11916d5df" => :el_capitan
    sha256 "3ee2001f87f2a58e698aeb0bfc413baa820184dba1caa2b3ec0a5a593a80d651" => :yosemite
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
