class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM.git",
      tag:      "v4.0.0",
      revision: "d73c6b530b39a18a3cacaafc4e42550be853c036"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "afbbbea1379862cdefaf71f2aab1135ae9bb4f9af502e0de9556ef8648c013b7"
    sha256 cellar: :any,                 arm64_monterey: "1c6ef8ed953b7272d93b5e73536cf31d4a2155f1c75d38bb237d600b946a0fde"
    sha256 cellar: :any,                 arm64_big_sur:  "d38658829bf657a634e7727ee432b37a993b8eb41109ca95dbfaab7e9b386fa5"
    sha256 cellar: :any,                 ventura:        "55ecb60dd24dec2681394999f727ac01bb8781130eb28e2a412aee9bcc5feb6c"
    sha256 cellar: :any,                 monterey:       "f2f56d570faec0e97b2a023da7e039d1ce9ac47549434a8a00cb93ac65cf3ecb"
    sha256 cellar: :any,                 big_sur:        "176d8873f4f2f70bc97bb3c99f5a268b0e3d62b7045e6599e7b65319f338a0b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "400e5d31f49a50c8e14d2722549c50f9a358b71299001f1d97940d8ee9d4d059"
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
      system "#{bin}/lightgbm", "config=train.conf"
    end
  end
end
