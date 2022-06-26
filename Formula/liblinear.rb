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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "975c5b08255f53fbbacbb035c510c01814ceb06af50b45a977cc67ce540ccb90"
    sha256 cellar: :any,                 arm64_big_sur:  "39e6e1934920fb81cfdc79e7a819fd2d0ef4caf5a253e97fa2b539c22789e198"
    sha256 cellar: :any,                 monterey:       "0e4819da9732ad41046313ecd8860bd62b85b83d6ac06d44cd854a387b441683"
    sha256 cellar: :any,                 big_sur:        "c0bd8407043a6ad8486ffd3306cf584d43eeffb9a06cdccf17219ffbc415eb2c"
    sha256 cellar: :any,                 catalina:       "c9b6d361976c6fa8350c9c34cc2f2b4a648d597f86d24752a1a0504697041794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "724bc7db06767acccb409cba7b7722bd3fd7eed64aa436c87f07331953b01ffc"
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
