class Libsvm < Formula
  desc "Library for support vector machines"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/libsvm/"
  url "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.21.tar.gz"
  sha256 "519e0bdc0e31ab8246e9035e7ca91f794c16084f80abe4dffe776261d23c772f"

  bottle do
    cellar :any
    sha256 "a5d6c626bdd7a1f1f708e5767637dd2ed89526567eb106b8c86d7b4910b30d8a" => :sierra
    sha256 "0fce8de31135d07cd0fdb3641ebad2dfa974cc764ebaf6687f37a3a69a745c3a" => :el_capitan
    sha256 "bdbaaa0c8be35d3424ace7a9fc4ff03158116c76151cbd2baa5361bd34db7b67" => :yosemite
    sha256 "dca4ebe29389222258e146be192f3d40d147c355751a9581b873d30b8f1a0f91" => :mavericks
    sha256 "dfc7c6015460c4ff7796725243644a7675eea48c870121e5e715c307cb3f3f66" => :x86_64_linux
  end

  def install
    system "make", "CFLAGS=#{ENV.cflags} -fPIC"
    system "make", "lib"
    bin.install "svm-scale", "svm-train", "svm-predict"
    if OS.mac?
      lib.install "libsvm.so.2" => "libsvm.2.dylib"
      lib.install_symlink "libsvm.2.dylib" => "libsvm.dylib"
      system "install_name_tool", "-id", "#{lib}/libsvm.2.dylib", "#{lib}/libsvm.2.dylib"
    else
      lib.install "libsvm.so.2"
      lib.install_symlink "libsvm.so.2" => "libsvm.so"
    end
    include.install "svm.h"
  end

  test do
    (testpath/"train_classification.txt").write <<-EOS.undent
    +1 201:1.2 3148:1.8 3983:1 4882:1
    -1 874:0.3 3652:1.1 3963:1 6179:1
    +1 1168:1.2 3318:1.2 3938:1.8 4481:1
    +1 350:1 3082:1.5 3965:1 6122:0.2
    -1 99:1 3057:1 3957:1 5838:0.3
    EOS

    (testpath/"train_regression.txt").write <<-EOS.undent
    0.23 201:1.2 3148:1.8 3983:1 4882:1
    0.33 874:0.3 3652:1.1 3963:1 6179:1
    -0.12 1168:1.2 3318:1.2 3938:1.8 4481:1
    EOS

    system "#{bin}/svm-train", "-s", "0", "train_classification.txt"
    system "#{bin}/svm-train", "-s", "3", "train_regression.txt"
  end
end
