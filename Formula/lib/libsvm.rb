class Libsvm < Formula
  desc "Library for support vector machines"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/libsvm/"
  url "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.35.tar.gz"
  sha256 "ea5633fc84b1c2fa58aa4c44b62e437573020297a1dfbe73bf1531ec817a8478"
  license "BSD-3-Clause"
  head "https://github.com/cjlin1/libsvm.git", branch: "master"

  livecheck do
    url :homepage
    regex(/The current release \(Version v?(\d+(?:\.\d+)+)[, )]/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "fbd7f0cb7371ece33c5cfef9a0de2c8ce9ae60975ca902621ff7767d3f4a489e"
    sha256 cellar: :any,                 arm64_sonoma:   "b0b42109fa5ef7614278c54c343022fc60f3946e7d1f110472e002e0a333dca8"
    sha256 cellar: :any,                 arm64_ventura:  "dec298a98db2de896176f6c2d0dd4a9304f8da4a3e2f3af3c90f097f41d7f6f4"
    sha256 cellar: :any,                 arm64_monterey: "9984ecea26fd1aab82612a0ac2a267dfe30ceb81ab8ae365027f2acfb6677ef5"
    sha256 cellar: :any,                 sonoma:         "cf42abb68e45caccd897b737ce1aa00b2c5f0e79f5c5336432e56171ebf2b95e"
    sha256 cellar: :any,                 ventura:        "7d908bc4532b8e00b9a03f91b7e67d6e279b51ec5a8ec67465ca914dd0b899f2"
    sha256 cellar: :any,                 monterey:       "ddaef78accfa874e5d2b3638b8dcd00f73ed979d012d6cb97307b56d72ee5311"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d98d136eb5efb5ac277db2ba33fc7ee191df107e74d6937ece0ed5f596a1a853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "180e48479f4ce02ec77db9750d16a1eb71f29768d90f4f012e152e5f542a6cdb"
  end

  def install
    ENV.append_to_cflags "-fPIC" if OS.linux?
    system "make", "CFLAGS=#{ENV.cflags}"
    system "make", "lib"
    bin.install "svm-scale", "svm-train", "svm-predict"
    include.install "svm.h"

    libsvm_files = buildpath.glob("libsvm.so.*")
    odie "Expected exactly one `libsvm`!" if libsvm_files.count != 1

    libsvm = libsvm_files.first
    libsvm_soversion = libsvm.to_s[/(?<=\.)\d+(?:\.\d+)*$/]
    lib.install libsvm => shared_library("libsvm", libsvm_soversion)
    lib.install_symlink shared_library("libsvm", libsvm_soversion) => shared_library("libsvm")
    return unless OS.mac?

    libsvm = shared_library("libsvm", libsvm_soversion)
    MachO::Tools.change_dylib_id lib/libsvm, (opt_lib/libsvm).to_s
    MachO.codesign!(lib/libsvm)
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
