class Liblinear < Formula
  desc "Library for large linear classification"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/liblinear/"
  url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-2.20.tar.gz"
  sha256 "3f9fef20e76267bed1b817c9dc96d561ab5ee487828109bd44ed268fbf42048f"
  head "https://github.com/cjlin1/liblinear.git"

  bottle do
    cellar :any
    sha256 "75e0289a341887b4db477a08c25eee23e9b07d00811c05c0a5922992da13f985" => :mojave
    sha256 "b95e7df876deaac16211dfa14ddc291925372fe2021629ac17827e7ec90c658b" => :high_sierra
    sha256 "f9caf0fc0bfd566faf7f2076e2a2d903d9ec3fad350b8e19307d13e3783d8f91" => :sierra
    sha256 "ea9543b48babe41506ef52ce61aee5659a50ad61e75ac21eb51832e1d7c8f306" => :el_capitan
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
