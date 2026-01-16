class Liblinear < Formula
  desc "Library for large linear classification"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/liblinear/"
  url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-2.50.tar.gz"
  sha256 "e5eeafe2159c41148b59304da2ba0ed12648e3d491ce2b9625058e174e96ca29"
  license "BSD-3-Clause"
  head "https://github.com/cjlin1/liblinear.git", branch: "master"

  livecheck do
    url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/"
    regex(/href=.*?liblinear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "084eda55e8b1e787d35ba4b64b07973f28c03ba3b80caf34476453bfc0aa6fd3"
    sha256 cellar: :any,                 arm64_sequoia: "1447af1433e4c22bb65f7d1483e80be28eef54f01ea4975cbaab5eeddcbf0329"
    sha256 cellar: :any,                 arm64_sonoma:  "06d144b0bf2dc670bcdc8f6be989fd72bc4cfe0ca62b232af14af2695fafd9e0"
    sha256 cellar: :any,                 sonoma:        "112816fd22beb8a5b8ee79f0fa0c6094c9813384de039df65874dad76fd4d090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c0831cc8dc54b0696cdeabb442f146bf430aa0547bb97e3240c5f51c0c135f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "746b7ce2c2f425061ad373dedcf34bb5daa031ebb059bbbc9424dbcd7f9ba9c1"
  end

  # Fix sonames
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/liblinear/patch-Makefile.diff"
    sha256 "11a47747918f665d219b108fac073c626779555b5022903c9b240a4c29bbc2a0"
  end

  def install
    soversion_regex = /^SHVER = (\d+)$/
    soversion = (buildpath/"Makefile").read
                                      .lines
                                      .grep(soversion_regex)
                                      .first[soversion_regex, 1]
    system "make", "all"
    bin.install "predict", "train"
    lib.install shared_library("liblinear", soversion)
    lib.install_symlink shared_library("liblinear", soversion) => shared_library("liblinear")
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

    system bin/"train", "train_classification.txt"
  end
end
