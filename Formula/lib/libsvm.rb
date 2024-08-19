class Libsvm < Formula
  desc "Library for support vector machines"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/libsvm/"
  url "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.33.tar.gz"
  sha256 "d5da12ccc3d0eed8453fbdf6fac7d9f0052f3e8a5f07a2174e4ef0a9d83dcdf8"
  license "BSD-3-Clause"
  head "https://github.com/cjlin1/libsvm.git", branch: "master"

  livecheck do
    url :homepage
    regex(/The current release \(Version v?(\d+(?:\.\d+)+)[, )]/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d515eb3c100c6160ea840eb440019875ef50953123642d23a2c2e44e9919ef1e"
    sha256 cellar: :any,                 arm64_ventura:  "6cf59fad5c5635f1257414997c04aed03b7ff0e4c5fe589e73ac1b5bb2a1113a"
    sha256 cellar: :any,                 arm64_monterey: "9f51dec822f2bf2b53c2f4c5d3b00f9adf7d6768f0cc4c7bac32e653b675dff8"
    sha256 cellar: :any,                 sonoma:         "c56ee63aedc0504e92ad09cfa114308a8d7acf09d5d72c5eb2f33646ecb03b18"
    sha256 cellar: :any,                 ventura:        "6ef903a143493d852a125769e1527c80f9b4a6d2ffadedc8b027041aef342f6d"
    sha256 cellar: :any,                 monterey:       "8be5f60c02ab83c5b0c23f4879e39604e74ef8b54b28d39b8e10b025e3c25b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "593498bfda45a86c323f7040f52d6aeb56e422dd3dcc8c290731f26e93c691d8"
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

    system bin/"svm-train", "-s", "0", "train_classification.txt"
    system bin/"svm-train", "-s", "3", "train_regression.txt"
  end
end
