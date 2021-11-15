class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM.git",
      tag:      "v3.3.1",
      revision: "d4851c3381495d9a065d49e848fbf291a408477d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "34610dd420b6e0e39f5de3575b99dc7991adfa0f8b6ebd032886b20e61596e68"
    sha256 cellar: :any,                 arm64_big_sur:  "3c8b86c37e5233ed06de0494fd8cdba6fa9faa91af97840f0a72c95fdfb092c4"
    sha256 cellar: :any,                 monterey:       "d0d1dbb78a2cb0f66096babb71eee9d31fd0fd4a34faaea6ea25eef88fd1f03b"
    sha256 cellar: :any,                 big_sur:        "a4d65f031a1b2af129f8cc3741e77721fc78ea8c832e848b731b1a144e43d8ab"
    sha256 cellar: :any,                 catalina:       "4b6a53e88126659be4d6c0a18e6d077cbbf9152d2753363749a29bf79153c4dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "083b5aa1adba57bc086d9917730672f2c4d2ab5f8b03ef55f999e1faf2596e56"
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, "-DAPPLE_OUTPUT_DYLIB=ON", ".."
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples/regression"), testpath
    cd "regression" do
      system "#{bin}/lightgbm", "config=train.conf"
    end
  end
end
