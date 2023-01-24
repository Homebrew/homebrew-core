class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM.git",
      tag:      "v3.3.5",
      revision: "ca035b2ee0c2be85832435917b1e0c8301d2e0e0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d2a734161a5fbb6521bf33881944def260f34ddb1141a832ad883766a80631d7"
    sha256 cellar: :any,                 arm64_monterey: "704d5d92951b9e10bc7fe95e6ba6a76319af8b5a8d8112b10e241aa01a70ae2d"
    sha256 cellar: :any,                 arm64_big_sur:  "977487ea6e9fd598d6a67ea4fba2fbf92482e5bc5f915fc9031df37cc2c97c67"
    sha256 cellar: :any,                 ventura:        "051d2d3205e2f51e7b8eae631257804a474a3f43d6b50e209ddd95c34067f402"
    sha256 cellar: :any,                 monterey:       "73a06375ad255e6566835a85a001abefa66ca2c3c208d8fe1fd219dec45d933b"
    sha256 cellar: :any,                 big_sur:        "894a6789f09ab9b80707b9cba0f9689e63c5c4b2ca4efd0efd1b2334a9da4ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8c9ad2079210dfcf902c8e655f917cd5c04380c775bfd9d6800561e27649f1b"
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
