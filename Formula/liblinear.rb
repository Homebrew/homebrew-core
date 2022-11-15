class Liblinear < Formula
  desc "Library for large linear classification"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/liblinear/"
  url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-2.45.tar.gz"
  sha256 "3c64eec45c01943a656baac7aeb8ffd782fe0aea53629aa9f5fdb8eec177c92f"
  license "BSD-3-Clause"
  head "https://github.com/cjlin1/liblinear.git", branch: "master"

  livecheck do
    url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/"
    regex(/href=.*?liblinear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c3c757ddd4f6f1aad3f422c1a82b61f593362886a726d13a8fa88e5692247222"
    sha256 cellar: :any,                 arm64_monterey: "1dc65a0cd23d37bc4ef5676080e6a0e6b953289152532586791f6117d51c2ffa"
    sha256 cellar: :any,                 arm64_big_sur:  "729f76538f19c370424f033c884e46a9cb83cdb99d64703d6e5f7345bb170cce"
    sha256 cellar: :any,                 ventura:        "bdb804716d739f566d8b1e9cd933183b2af7316e900747fd4fad0526150b4439"
    sha256 cellar: :any,                 monterey:       "5a5b15fee1584548ebdeb166c81efda7038d6941501b685be49775f9ed4775c2"
    sha256 cellar: :any,                 big_sur:        "356369ca1df9b188b922ce4bfd74f1e215eaa766a656b6ae0e9085314138d351"
    sha256 cellar: :any,                 catalina:       "a610ba5a1bcb6ee808f10c1bb2877139ee95d67406beb917f89eabf266445cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d65dafb6eac0a56233687510ad736495633467dbdb1f15c976ece952ecca15be"
  end

  # Fix sonames
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/7aed87f97f54f98f79495fb9fe071cfa4766403f/liblinear/patch-Makefile.diff"
    sha256 "a51e794f06d73d544123af07cda8a4b21e7934498d21b7a6ed1a3e997f363155"
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

    system "#{bin}/train", "train_classification.txt"
  end
end
