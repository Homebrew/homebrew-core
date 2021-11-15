class Liblinear < Formula
  desc "Library for large linear classification"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/liblinear/"
  url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-2.43.tar.gz"
  sha256 "02bad43d745e2796f39a08ac9d117770e71939ef06b1ee7afc6ab7909e304807"
  license "BSD-3-Clause"
  head "https://github.com/cjlin1/liblinear.git"

  livecheck do
    url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/"
    regex(/href=.*?liblinear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "1331f0607a09c1c2ab02e24b79a3923d4d6b42db87663c2cc02a08b33462ebd2"
    sha256 cellar: :any, arm64_big_sur:  "aca85fb0c9bedeb95d6f9ebfa7f276ecc730dc62f4c4f57280cc2b8d935d04ea"
    sha256 cellar: :any, monterey:       "f7397f0a43f8de1cb2add67a3a2b16c2e45997259ed227a5541ea20a7040b0ab"
    sha256 cellar: :any, big_sur:        "6cb465de42446200b77938139b8249b0feea08442b5cca7b72549f2d97e883dc"
    sha256 cellar: :any, catalina:       "d1e10b22338d6a746fa8c05b68133f6439c58c1ed3a4728b1c5a4e7e7d3d7d6e"
    sha256 cellar: :any, mojave:         "60fc530063ad3f9f304cb7cfa739aa6974ed6f89b0f3218dceb6f4fc060d2e77"
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
