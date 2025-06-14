class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.1.5.tar.gz"
  sha256 "1c6949032069d5ebea438ec5cedd602d06f40a92ddf0f0d9dcff0993e5f6635c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89240a2e31cee0b79ba3a4fb8cb78b10ef845bf40c7b70cbc8806b5666e045b2"
    sha256 cellar: :any,                 arm64_sonoma:  "148859c5e90af9564b39395169d6272659b9d3ecb0865bcb4c4c2edb43229f86"
    sha256 cellar: :any,                 arm64_ventura: "26d060ff1be7e7ccceab0d06c40ee8f4a783001ad6e56babfc6ca61e4081b180"
    sha256 cellar: :any,                 sonoma:        "3faf4a00a950b7a9ca0ff2fb0b6f2cb1eaa31fd1a6b76489ec8f58b3fe6c988f"
    sha256 cellar: :any,                 ventura:       "b54295e1c094c20fecabec2f79b1f2774b86d7196d17315f5c58b87a74039f84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea0f73965cd06d118e9a59a8de81b92c5b09f1067932ce65314ea8d4f3e8e87a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "898ebf78da50a5aac02b9ab4c9bfd15ba99ef92c8ece46a38b9c4a1839b3e1d2"
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
