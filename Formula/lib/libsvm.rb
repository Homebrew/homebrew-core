class Libsvm < Formula
  desc "Library for support vector machines"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/libsvm/"
  url "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.32.tar.gz"
  sha256 "8644cc6518ca88bbc50d8c8ead1734f1ab9b6f17017045ef9ae38773aa653dad"
  license "BSD-3-Clause"
  head "https://github.com/cjlin1/libsvm.git", branch: "master"

  livecheck do
    url :homepage
    regex(/The current release \(Version v?(\d+(?:\.\d+)+)[, )]/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fe235819b910f8d4076349a0c777525baa46f469cca14821a80775d6cad6ab0e"
    sha256 cellar: :any,                 arm64_monterey: "9267ca6d537c962fecbfc3f9478487d172cc150e3bd5b26a6e88ae020b48c21b"
    sha256 cellar: :any,                 arm64_big_sur:  "dfead0cdebbbed12bf34e06ff4c058ce528f207ea8aba50c4e0495dc2c4a97fe"
    sha256 cellar: :any,                 ventura:        "a00f5eb69a10446eafbe0b16be164a28e3ef03db654ecf18baaedc8f0db12e2f"
    sha256 cellar: :any,                 monterey:       "8da95e20f0b0ff7560004e15fab010f1aae1486326ab9d617f7e06de0b3e2b5e"
    sha256 cellar: :any,                 big_sur:        "cc6ee0e7e2532a05a9b82beec1a8ca04e7c1380f9d6634a2b45a79e6479c4d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "464056f924539b980646498a4b2ec99422656e35a676c2d1439064df97609b44"
  end

  def install
    ENV.append_to_cflags "-fPIC" if OS.linux?
    system "make", "CFLAGS=#{ENV.cflags}"
    system "make", "lib"
    bin.install "svm-scale", "svm-train", "svm-predict"
    lib.install "libsvm.so.3" => shared_library("libsvm", 3)
    lib.install_symlink shared_library("libsvm", 3) => shared_library("libsvm")
    MachO::Tools.change_dylib_id("#{lib}/libsvm.3.dylib", "#{lib}/libsvm.3.dylib") if OS.mac?
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
