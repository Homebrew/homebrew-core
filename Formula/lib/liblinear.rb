class Liblinear < Formula
  desc "Library for large linear classification"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/liblinear/"
  url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-2.48.tar.gz"
  sha256 "72ea3853a9fb430b49c3196177d8acdffd2dadb5901832ee323465792087e8cc"
  license "BSD-3-Clause"
  head "https://github.com/cjlin1/liblinear.git", branch: "master"

  livecheck do
    url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/"
    regex(/href=.*?liblinear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c8c537286177821c0bd2d45919a47cc842c789fff679b2f054e5adc008edf228"
    sha256 cellar: :any,                 arm64_sonoma:  "7bcb360515141b322d2b34e29e172b8f332d96c92122811611e07e4a1b4a1846"
    sha256 cellar: :any,                 arm64_ventura: "90961753c75dfcc6028d8646889e214359b6e3c540455bd5cc8bd21cf0d36b8c"
    sha256 cellar: :any,                 sonoma:        "a33cab9994c8a76fa5dd80d94c736cb48b520100f590fb5309332c0edb08d02e"
    sha256 cellar: :any,                 ventura:       "3ff7de89979c7836bb6aaeeececbbd7a93feba336a2e65c6d473fdf8973002b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5df01b9f8e93a7429b42d4d9925287c5ca3456cfccac4c3e5fb0a4cae22c7218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ad447cb4fdfe17f95da5b04cdc815b749f94f877d57808cc25ee87b850252d3"
  end

  # Fix sonames
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/bac35ae9140405dec00f1f700d2ecc27cf82526b/liblinear/patch-Makefile.diff"
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
