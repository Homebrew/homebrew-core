class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v2.1.7.tar.gz"
  sha256 "0eed39319f139afde8515010ff59baf24de9e47ea316a315398e8027d198202d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f789cf5d97f314c7d49563eee1e694fba7ce430983e4b661cd5d43312759df34"
    sha256 cellar: :any,                 arm64_sonoma:   "608b682e6ccd0030f60d6702909053c79ef9e3a77a3933d4b1354a481390d6c7"
    sha256 cellar: :any,                 arm64_ventura:  "accd89968019adbd6f0c2935d8c45fd7d1e3ded346d091e5f0a7ed8fa148d938"
    sha256 cellar: :any,                 arm64_monterey: "a6f3fee4cb7ec76cfd3b68ea5f73439d6ca8433fc7ae0f07423aac3eabac4939"
    sha256 cellar: :any,                 sonoma:         "4b945d8282ba568c22c75a0cebaaa2ab50cb100331d83bd79fdaee1fdd4898c6"
    sha256 cellar: :any,                 ventura:        "cfa0af1557483f96b8d09c6c24397d861b37d034e395ca2c93a337ee0b460712"
    sha256 cellar: :any,                 monterey:       "d20a3725ded827d7ddbdc09f63efa2fb5a4fcce439c882869d6cca281fb25a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31c18bcb99d1c0d20b91f7f09f67824cac3af06a2abc4afda6d8e89acaa28b53"
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
