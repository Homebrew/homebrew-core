class Liblinear < Formula
  desc "Library for large linear classification"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/liblinear/"
  url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-2.49.tar.gz"
  sha256 "166ca3c741b2207a74978cdb55077261be43b1e58e55f2b4c4f40e6ec1d8a347"
  license "BSD-3-Clause"
  head "https://github.com/cjlin1/liblinear.git", branch: "master"

  livecheck do
    url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/"
    regex(/href=.*?liblinear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d4d7f915315284cf9989f3c45b3af04e408ad800fc1a77c920bb61cff10c77dd"
    sha256 cellar: :any,                 arm64_sequoia: "b557d3524f23633e3571f94c56acb5d26cf6b3e03133ced6ba3fb94fad9cfbed"
    sha256 cellar: :any,                 arm64_sonoma:  "cd7cb1bc31153ba544dae17865420917a5dec39c597ee760ed0c427f8bfb0a09"
    sha256 cellar: :any,                 arm64_ventura: "0e7ea4738b47faa2ddcb74f48fe653721e925b7e8599ce7818833e225b4014cf"
    sha256 cellar: :any,                 sonoma:        "25bd99b24fbbe7bd3563ac7ca64f4c8425002bddc87f81767b461a84ef267730"
    sha256 cellar: :any,                 ventura:       "e43397dc12d8d6beec494dcd5b58ff02053215c06bfd077d3becc7a876c8cfc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c520e4bf49d57422d14a3ae85f6601af7705a45581eca47307513f7f3a20aea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15155ee93eca57ffb0571839db5e554c09d2d04e9a80ef2ea8fc0471bb37f29a"
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
