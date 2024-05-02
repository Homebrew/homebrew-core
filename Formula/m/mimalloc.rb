class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "ef31a7c593866a35883b2090654a8d6136a1cf06f22b577b4e1c818b1b0a8796"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5c21d5d93e4913de35c2f2c525108e72abc1b2e93aa6d5f1f98c89324dc3bbfd"
    sha256 cellar: :any,                 arm64_ventura:  "aaa6714b65da5b597e8f674ea6f5d0f0074efff2f32e4935783c6fff2062a178"
    sha256 cellar: :any,                 arm64_monterey: "b046a150b354dcd245c4d96821969085e41fb61f3a6889cb42300e089ad79c7b"
    sha256 cellar: :any,                 sonoma:         "2d1e16d3bbb96632f40f9830a84b52639ed97f8a91c7b3f4056c626892ffbe82"
    sha256 cellar: :any,                 ventura:        "b241ad53415421db87601dd276acbd4bd9086f63dbd0021a3b7279cf38449fe6"
    sha256 cellar: :any,                 monterey:       "fb78a1a6d34175927f82060b23def6bf895488c7da9b826cb056adfcee73e137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43c3224f21262708ac0b72efeea370402a3312769d230aa86767f0c30d153f71"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match "heap stats", shell_output("./test 2>&1")
  end
end
