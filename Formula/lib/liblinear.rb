class Liblinear < Formula
  desc "Library for large linear classification"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/liblinear/"
  url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-2.47.tar.gz"
  sha256 "99ce98ca3ce7cfb31f2544c42f23ba5bc6c226e536f95d6cd21fe012f94c65e0"
  license "BSD-3-Clause"
  head "https://github.com/cjlin1/liblinear.git", branch: "master"

  livecheck do
    url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/"
    regex(/href=.*?liblinear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ebbb496439ed5cbd2934fe7204ccad94c56071a10ef3dbccbebb2d205798b000"
    sha256 cellar: :any,                 arm64_sonoma:   "447ba6aa36bec6cb65825dd9d6aad55e07e2eb9cb10537a4ad142546bb015e1f"
    sha256 cellar: :any,                 arm64_ventura:  "2f7f959e3a537760a29d4f4f4ff949bf5ef8f7206dbbb7f48492e8b733978f78"
    sha256 cellar: :any,                 arm64_monterey: "3c2ee17592c9ff78f3b58baf9bdae899be678d7c073b471896314896c854c540"
    sha256 cellar: :any,                 arm64_big_sur:  "c0f811408e6e5d5a29d7c8d94b89d92980d1b149b1c909413bae383a0df0cf31"
    sha256 cellar: :any,                 sonoma:         "0fafcc1fcf64b944113137b103a7ff4900ceea6c96672979b79a7a88150869c2"
    sha256 cellar: :any,                 ventura:        "785f3d2ae8640b9689caa8982f13119ad27b88868a432c9ccaaec6a345e2ac68"
    sha256 cellar: :any,                 monterey:       "2b5c4306ba3b88b67d803d0b5ff4562889f1516d5e2a9b479c3c2ee3eb573a53"
    sha256 cellar: :any,                 big_sur:        "26e5cca0e853ce2014ccf29cf38513e5a852e4c4a65b4fe1f39220f4a176d6f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed4f81487889a1f54491aed3e6ce5b492c60a16c8e59d782c94c552fc46311dd"
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
