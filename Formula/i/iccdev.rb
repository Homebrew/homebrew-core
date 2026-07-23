class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.2.2.tar.gz"
  sha256 "fb6db7dbffade564334654ced2537b3ad4c4dffbea858f081818c7dade65d155"
  license "BSD-3-Clause"

  # Skip `wasm-` tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "10b0fca7b39a209a1e01aa6fd2c10b15a611de2796929b8f2110a938bdba5f99"
    sha256 cellar: :any, arm64_sequoia: "3f235ffec84904d51a82042a52015b9331d060f45df6023b9cad668c82dab44c"
    sha256 cellar: :any, arm64_sonoma:  "c77cf3ecb06d59592f3a8f9852db148301b616bc3621aa5db48feeb5a347c2f6"
    sha256 cellar: :any, sonoma:        "9ce942f8f5363a10491dc675c273f9673030fe488cfcc7266d14ecff88722acb"
    sha256 cellar: :any, arm64_linux:   "eac0ca9305dcece50b9b342a89e46447c5849f597f1fc8bf764402f55d1d0472"
    sha256 cellar: :any, x86_64_linux:  "52965ea9b8b645374bd20afc2c3bf5c509ff59c43986417becaa9d46d5653aaf"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "wxwidgets"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", "Build/Cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "Testing/Calc/CameraModel.xml"
  end

  test do
    system bin/"iccFromXml", pkgshare/"CameraModel.xml", "output.icc"
    assert_path_exists testpath/"output.icc"

    system bin/"iccToXml", "output.icc", "output.xml"
    assert_path_exists testpath/"output.xml"
  end
end
