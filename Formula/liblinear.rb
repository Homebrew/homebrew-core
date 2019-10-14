class Liblinear < Formula
  desc "Library for large linear classification"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/liblinear/"
  url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-2.30.tar.gz"
  sha256 "881c7039c6cf93119c781fb56263de91617b3eca8c3951f2c19a3797de95c6ac"
  head "https://github.com/cjlin1/liblinear.git"

  bottle do
    cellar :any
    sha256 "e232d6644b55148f5fef3e478006dbd85b9b834299f7c97bee6313806204685a" => :catalina
    sha256 "1ab5662ee30a21a4c83b180d62553e886043b56fc094b66501588b965ecac3ce" => :mojave
    sha256 "bb1f3367533f79366c2e40b31f5e14fc0831537789e28da3aec5e7210b898c10" => :high_sierra
    sha256 "8ea77b137e26d69cddd966a8d95da70ae4366b8bf0c673307e1579bc4f9b791a" => :sierra
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
