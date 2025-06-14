class Libbsc < Formula
  desc "High performance block-sorting data compression library"
  homepage "http://libbsc.com"
  url "https://github.com/IlyaGrebnov/libbsc/archive/refs/tags/v3.3.9.tar.gz"
  sha256 "d287535feaf18a05c3ffc9ccba3ee4eacd7604224b4648121d7388727160f107"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c7ed848197e074d4ffbf597c051dcc37399d2d589c6ada3a15f90fd049859470"
    sha256 cellar: :any,                 arm64_sonoma:  "e9f13fa761075788e61ac51a14ab27649231f3355f7f7fe3d56d848c74714e96"
    sha256 cellar: :any,                 arm64_ventura: "5d49a44a479d5de112bc9bd95c88ab7b14fcd9e86f099e5c335c912df1610a90"
    sha256 cellar: :any,                 sonoma:        "d901c26e237fd703be8440ff7f5e3004309d876be6beeb6dec4360f33af8c399"
    sha256 cellar: :any,                 ventura:       "b3aecda9cb9b4592b4b92191c99d14532127ad1af91874aa1c6963a1c010e4ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95b7b546d36cecdefc38a60d52c6360e704c60877584786623f2fc7e841909b8"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "bsc", because: "both install `bsc` binaries"

  def install
    args = %W[
      -DBSC_ENABLE_NATIVE_COMPILATION=OFF
      -DBSC_BUILD_SHARED_LIB=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"bsc", "e", test_fixtures("test.tiff"), "test.tiff.bsc"
    system bin/"bsc", "d", "test.tiff.bsc", "test.tiff"
    assert_equal Digest::SHA256.hexdigest(test_fixtures("test.tiff").read),
                 Digest::SHA256.hexdigest((testpath/"test.tiff").read)
  end
end
