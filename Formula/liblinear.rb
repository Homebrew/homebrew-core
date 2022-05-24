class Liblinear < Formula
  desc "Library for large linear classification"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/liblinear/"
  url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-2.44.tar.gz"
  sha256 "45572b99d4eeffc3e8ad7b72c27370be867edf3523c396d8b278a2c873bfbb5c"
  license "BSD-3-Clause"
  head "https://github.com/cjlin1/liblinear.git", branch: "master"

  livecheck do
    url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/"
    regex(/href=.*?liblinear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "0f496d85ea12f35bd6b69d1849d8db10d77dfc598b9b1a2e52d497a361efef0a"
    sha256 cellar: :any, arm64_big_sur:  "30ae9909931985aa38757d4e672de1443d1b90ddcba1adcf3fb6f032793c41e8"
    sha256 cellar: :any, monterey:       "44f98075df89547f680f8ff9c22c855ba8abb37e748bb715e459688a37a05a13"
    sha256 cellar: :any, big_sur:        "0254d6ff53ed4b920f30f7825def66c7620f513a80d6b57304ecb0df26708810"
    sha256 cellar: :any, catalina:       "c0bb83cc29780a4433b1c8b95b0f9232277e1b3337e308c8b0761faa20fbf7d2"
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
