class Libsvm < Formula
  desc "Library for support vector machines"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/libsvm/"
  url "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.31.tar.gz"
  sha256 "00ab561f48df5fc92a84209ad8fe5199eaf2e519b3c279bacfc935978a75cf1f"
  license "BSD-3-Clause"
  head "https://github.com/cjlin1/libsvm.git", branch: "master"

  livecheck do
    url :homepage
    regex(/The current release \(Version v?(\d+(?:\.\d+)+)[, )]/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "04ed945a04d36a914644ac10ceebc9be92963805af6d24fa6ee4993dcab5592c"
    sha256 cellar: :any,                 arm64_monterey: "86e58494e6df337061437029aa045784f9a8c7ab2aeeda076ee79faf0778c9ab"
    sha256 cellar: :any,                 arm64_big_sur:  "89c5d5a9b65341fabf480afd68c5606a251db37c0f938463d3df00843bad5fa5"
    sha256 cellar: :any,                 ventura:        "3b2b20850583a8a46dad9b735e8f5c74426a5b4731d251d27ba7ff7496a39224"
    sha256 cellar: :any,                 monterey:       "aaa77406c7524ae2f7f2f78916a5700f43d4c8bb69accbf6fed1f6a181366bdc"
    sha256 cellar: :any,                 big_sur:        "5fe2ddee2e10662c015bd6a620efee7066a64ff102d31af52fc5683ade474572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0aa7992ca136c00910a713181370a13f0c56e66ebd4590183d52b21eef3aca5"
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
