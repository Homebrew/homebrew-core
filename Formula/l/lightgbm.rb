class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM.git",
      tag:      "v4.5.0",
      revision: "3f7e6081275624edfca1f9b3096bea7a81a744ed"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "978165b249362451083befd02d5a896a162576adf9e3d43f1f21e9013ca42468"
    sha256 cellar: :any,                 arm64_ventura:  "d045a7be5f3f48f88ce1b04c9c64c45c835110f4675f78f29d1302de708548b4"
    sha256 cellar: :any,                 arm64_monterey: "522a7d56a64386fde0e8b7df39c1a59a9040833b4063246abf0a229ec2d74fb6"
    sha256 cellar: :any,                 sonoma:         "db82709068ba820c02629798f393d08165c062a49747cdaccb33cbbc9e9cf187"
    sha256 cellar: :any,                 ventura:        "d873dbe714ff9f81371a65a5986cacd36eb9330dd5afc969462064943a54bcfd"
    sha256 cellar: :any,                 monterey:       "05623d0d1c032e242986788bb5f6a74b23b39165ac9f1c6abca0a9582205efb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d1a4895d4c9783ef4f1d218571ff677754a8c52cc6283d314e0d9d619c486a6"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DAPPLE_OUTPUT_DYLIB=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples/regression"), testpath
    cd "regression" do
      system bin/"lightgbm", "config=train.conf"
    end
  end
end
