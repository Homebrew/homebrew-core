class Plutovg < Formula
  desc "Tiny 2D vector graphics library in C"
  homepage "https://github.com/sammycage/plutovg"
  url "https://github.com/sammycage/plutovg/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "7bd4e79ce18b1d47517e7e91fbb7cf19d4f01942804a519bc7c0bf32b6325dd5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f152f77d73192095314d68f309103f56fd4cdf9c72d109337c96cc1ce77ae61"
    sha256 cellar: :any,                 arm64_sequoia: "01949b2a6657b3238515f7a6aca2b0fbeaa54b6d843690e13a5046ba5396ec72"
    sha256 cellar: :any,                 arm64_sonoma:  "92905b52c972786451395a10f321dcf8b10dbd8042f1987a4f8b60687956e88c"
    sha256 cellar: :any,                 sonoma:        "2e7e3cb897b94ff5aefc38c6e2ddf768d9fe8593208877777a0398cf67a7025a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "119e6c35d5c8dc051d244e5ae8a30ad374b4bdf9446adf59a0f5d05d96f7e9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49ff00cd89be194a241c1cc4b96f0ea61263be83fe7d3cd3e1c7e25c8fa63129"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DPLUTOVG_BUILD_EXAMPLES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/smiley.c"
  end

  test do
    system ENV.cc, pkgshare/"examples/smiley.c", "-o", "smiley", "-I#{include}/plutovg", "-L#{lib}", "-lplutovg"
    system testpath/"smiley"
    assert File.size("smiley.png").positive?
  end
end
