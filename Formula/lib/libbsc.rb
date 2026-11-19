class Libbsc < Formula
  desc "High performance block-sorting data compression library"
  homepage "http://libbsc.com"
  url "https://github.com/IlyaGrebnov/libbsc/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "49c98200c0cf7bb942bc0313afb28c7a775f843532b2ced80bbf57ecae2090d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cd5efed0dfa81b74813899fe7e035084c44d8e0fd22f3c92fff02af18d750502"
    sha256 cellar: :any, arm64_tahoe:       "9d6a1f9492a19074c4e8432c0891dcae76d25d16ae92619fa090f541eaac6ee5"
    sha256 cellar: :any, arm64_sequoia:     "b28efd13ee30d9d53649787fc3e7a0ee2dc683a1a716a3c407c004cc7bcee8cb"
    sha256 cellar: :any, arm64_linux:       "2da1f787b6375037e4d3a463282a1ecb0f642fd56dd48f7a88ba3c623a20171a"
    sha256 cellar: :any, x86_64_linux:      "2131ba885502308ea1c2ff5992a736638227d995d78314d02bbfe36daa72defa"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "bsc", because: "both install `bsc` binaries"

  deny_network_access!

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
