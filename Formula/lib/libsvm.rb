class Libsvm < Formula
  desc "Library for support vector machines"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/libsvm/"
  url "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.36.tar.gz"
  sha256 "bc92901fbb928c44bb6d0c38189624c7443bcdbf1dd8350b4914e58e57b93c11"
  license "BSD-3-Clause"
  head "https://github.com/cjlin1/libsvm.git", branch: "master"

  livecheck do
    url :homepage
    regex(/The current release \(Version v?(\d+(?:\.\d+)+)[, )]/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6546714deddbd0e4a709d6987ffaaf66342b9bfa032f2ebb3ac8138ee1b9be07"
    sha256 cellar: :any,                 arm64_sequoia: "07c47f5b7781dd3fffb83c47d6ea6568e7979e1222eb214c7a85d1323841a91a"
    sha256 cellar: :any,                 arm64_sonoma:  "491c601bed6a963a50717df1a90b1a0c9a73f73b19f64778239a1668edb96440"
    sha256 cellar: :any,                 arm64_ventura: "4025272abab33c159ef9ce0133a1716d3936d2b10a0f26c630a68e19547c4bb5"
    sha256 cellar: :any,                 sonoma:        "0bb3867e246b44702d4f0504b0fd8cbc52a7995d9c083ad1be071eedac630f33"
    sha256 cellar: :any,                 ventura:       "7756ddc93d633b6de91c42f80ea3fba436cdfd9a9eb7af9f7413ec9f15ba1af5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfdef8c630fd3e6fd561ae9b0fe3d3063777ddb0553e06b00477fa29bf28f1a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1c622afb8f5923a625dbdd52197af588febd196e1d2eabfa3e1c9b3664e4386"
  end

  def install
    libsvm_soversion = nil
    inreplace "Makefile" do |s|
      s.gsub! "libsvm.so.$(SHVER)", "libsvm.$(SHVER).dylib" if OS.mac?
      libsvm_soversion = s.get_make_var("SHVER")
    end

    system "make"
    system "make", "lib"
    bin.install "svm-scale", "svm-train", "svm-predict"
    include.install "svm.h"
    lib.install shared_library("libsvm", libsvm_soversion)
    lib.install_symlink shared_library("libsvm", libsvm_soversion) => shared_library("libsvm")
  end

  test do
    assert_path_exists lib/shared_library("libsvm")

    (testpath/"train_classification.txt").write <<~EOS
      +1 201:1.2 3148:1.8 3983:1 4882:1
      -1 874:0.3 3652:1.1 3963:1 6179:1
      +1 1168:1.2 3318:1.2 3938:1.8 4481:1
      +1 350:1 3082:1.5 3965:1 6122:0.2
      -1 99:1 3057:1 3957:1 5838:0.3
    EOS

    (testpath/"train_regression.txt").write <<~EOS
      0.23 201:1.2 3148:1.8 3983:1 4882:1
      0.33 874:0.3 3652:1.1 3963:1 6179:1
      -0.12 1168:1.2 3318:1.2 3938:1.8 4481:1
    EOS

    system bin/"svm-train", "-s", "0", "train_classification.txt"
    system bin/"svm-train", "-s", "3", "train_regression.txt"
    return unless OS.mac?

    assert (lib/shared_library("libsvm")).dylib_id.end_with?("dylib")
  end
end
