class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.2.7.tar.gz"
  sha256 "33621bea902711639b8f83128e64685ffc8224a65443625530747603a2d8726d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16d4d25364809b2040df7ffe0ec3cf47d7207c9c0ae0109255ed21cd7cc6600e"
    sha256 cellar: :any,                 arm64_sequoia: "1826ca9e06e2ef683d66cfdf4bbbe01995fed8a9f1a513572863be15416b4e80"
    sha256 cellar: :any,                 arm64_sonoma:  "591c1738cf48f244a2fbd9a79cfd89d9c40d4207efd1eb60451a4a233286a115"
    sha256 cellar: :any,                 sonoma:        "d779c65f26702e21b83811e15dcee9f544c8658a4d85fa206b6779a1eab75dac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "761330f4930b0faae8680e3f13c3afe9b27edfd538a04e5a038bab56cad139fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "176610b6c2dfc5a0588633aad6c9f511fa349b12b74fb6ce76060b8d1f6a04bc"
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
    assert_match(/pages\s+peak\s+total\s+current\s+block\s+total/, shell_output("./test 2>&1"))
  end
end
