class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/refs/tags/v1.2.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/brotli-1.2.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/brotli-1.2.1.tar.gz"
  sha256 "98d35d11a78dc453aebb7d10c3748f3f73ff78c8267c0dc697b8631f67bf7e8f"
  license "MIT"
  compatibility_version 1
  head "https://github.com/google/brotli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ba4564da654b3cbc6a143d98194a5c0a4971976d5190c5627ed0b76c5c971b8f"
    sha256 cellar: :any, arm64_tahoe:       "c5a6fba2965b2423acfbf5084a4d8291bf95b96bbc64b534c8ef83a480413e49"
    sha256 cellar: :any, arm64_sequoia:     "7b92f3978056e44ac3f4bb6f5fc1ec31278a6b5972706236e8988e7c255cb3d4"
    sha256 cellar: :any, arm64_linux:       "460dda539a03bf4f7d821763d20351c9207683321611fde79da080e5302f69b5"
    sha256 cellar: :any, x86_64_linux:      "cb1fe9a81c06db13b0c0824450e9616d0f2a633f03f83047d1dfa88e4f981981"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build", "--verbose"
    system "ctest", "--test-dir", "build", "--verbose"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install buildpath.glob("build-static/*.a")
  end

  test do
    (testpath/"file.txt").write("Hello, World!")
    system bin/"brotli", "file.txt", "file.txt.br"
    system bin/"brotli", "file.txt.br", "--output=out.txt", "--decompress"
    assert_equal (testpath/"file.txt").read, (testpath/"out.txt").read
  end
end
