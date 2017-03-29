class Liblinear < Formula
  desc "Library for large linear classification"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/liblinear/"
  url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-2.11.tar.gz"
  sha256 "9e9bfaa9aa736c7d58b434a05365e5aa79aceab67e9c265d79a4e92a81f2479f"

  head "https://github.com/cjlin1/liblinear.git"

  bottle do
    cellar :any
    sha256 "c84311ed57023b4f3e8f50a08c2057e77d5334e4d48544235ea9f6d99e8d3b5c" => :sierra
    sha256 "dab9f6a7708156bf6f28f61bb98b4f25bba7e24a712a1d1e982540594bf7bf37" => :el_capitan
    sha256 "573b3d217a292c5f180c9be565f03f13d279400d48a22dc817e05fb069e1c59b" => :yosemite
  end

  # Fix sonames
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/941ec0ad/liblinear/patch-Makefile.diff"
    sha256 "ffb5206f0a6c15832574ec77863cda12eb2012e0f052bacebfe1ad722d31ea22"
  end

  def install
    system "make", "all"
    bin.install "predict", "train"
    lib.install "liblinear.dylib"
    lib.install_symlink "liblinear.dylib" => "liblinear.1.dylib"
    include.install "linear.h"
  end

  test do
    (testpath/"train_classification.txt").write <<-EOS.undent
    +1 201:1.2 3148:1.8 3983:1 4882:1
    -1 874:0.3 3652:1.1 3963:1 6179:1
    +1 1168:1.2 3318:1.2 3938:1.8 4481:1
    +1 350:1 3082:1.5 3965:1 6122:0.2
    -1 99:1 3057:1 3957:1 5838:0.3
    EOS

    system "#{bin}/train", "train_classification.txt"
  end
end
