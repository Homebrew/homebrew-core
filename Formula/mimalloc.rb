class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "38b9660d0d1b8a732160191609b64057d8ccc3811ab18b7607bc93ca63a6010f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a7d427a29635c4e4bb8a3b48e14cc519381fe5c5a218d7810fd84af50edfe886"
    sha256 cellar: :any,                 arm64_monterey: "f29fe8e8629032bddbfa8a5a1c17db45214f5455059be659399519bb61ab5846"
    sha256 cellar: :any,                 arm64_big_sur:  "57f7e12956b78fdb7e8d8be305cf8261356a1d9680fb02048d78afd86c7e7434"
    sha256 cellar: :any,                 ventura:        "14384642a066be467f26d21149e59b797439a4042501c33d09461811a053416a"
    sha256 cellar: :any,                 monterey:       "c898f23759062f216924056d5989cde7da69128032a5c78826322cb653a2d67b"
    sha256 cellar: :any,                 big_sur:        "92cdc362e9c109e8eac068dec90c4eb04ae7acbbe090dcb1e4eaca2e4515c217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1bc9cc27d1e233329ae359a83b1aa970d018ed3c4a6dd73f53ce01a5471462d"
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
