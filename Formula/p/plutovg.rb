class Plutovg < Formula
  desc "Tiny 2D vector graphics library in C"
  homepage "https://github.com/sammycage/plutovg"
  url "https://github.com/sammycage/plutovg/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "bea672eb96ee36c2cbeb911b9bac66dfe989b3ad9a9943101e00aeb2df2aefdb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "22711ec01c6c22f80d3d08b7dd9654f40b9ca652a739f6a69e5b78461f31ce05"
    sha256 cellar: :any,                 arm64_sequoia: "774025b21d030a547097e0b34ee8cb92698daeef0a4f5e0de33f5795c5af3607"
    sha256 cellar: :any,                 arm64_sonoma:  "a712898f39053da6b3910d408854e8e9b534720fe613ef755f4c144b0773b351"
    sha256 cellar: :any,                 sonoma:        "448ad0244f6b6aecc8b3fde9de6ae55f447adbe8720f2d0b499968621808ec82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a3aa64b816fcea3ca52c7ea9bc13db1bc0583a39c0426439b816fbda15c7df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e453529bb5bfbdb2ce7651f6df369e2a02c14140e8434e309e8bb3eba08787a"
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
