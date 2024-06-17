class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM.git",
      tag:      "v4.4.0",
      revision: "271d1ffdf847aeda0d7aa3351bd3fc1ee952dbe6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "63abe5178fee95e741353a61815e1b38d2995d69b4001a9a44565906a82a7796"
    sha256 cellar: :any,                 arm64_ventura:  "068b324396ef9a6a3c9bb6e9e607ba43f276db2fa0841c40eace87d21ea1af50"
    sha256 cellar: :any,                 arm64_monterey: "cee2258e46e5962c7743764886d6f6c6288e39d62394f2cc383cfb7c816b9bfa"
    sha256 cellar: :any,                 sonoma:         "402e4b2b060bfdb8bbfe8916faeef5ab1d334dbb5baef5dd00e493207942f894"
    sha256 cellar: :any,                 ventura:        "ac51862b246ee4959ac84f2bfa70d1b32714eb1e5b4d913ee604cc24a5f3e682"
    sha256 cellar: :any,                 monterey:       "6faf17bb9fd4e4366f0e480fd7067a096ebb5141bef105efc9c96a24ae28f0e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a8545d49cac4f6f5f7ab2609e61f58bb0691acdb44f89bebd30b667eaf95c3c"
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
