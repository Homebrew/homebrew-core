class Plutovg < Formula
  desc "Tiny 2D vector graphics library in C"
  homepage "https://github.com/sammycage/plutovg"
  url "https://github.com/sammycage/plutovg/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "8fd6e8b6505d38483d996c673ba0bfbcfe81a7a4a94a7b320cc81a4fbbe49873"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dee9c2d51a22a84614d430cf4e29516fd27a9325e9383d918670dad525e7c2ee"
    sha256 cellar: :any,                 arm64_sonoma:  "e0b3ca709ac2d29698c70df9f46aa76c32e757ce9765ef1f0ff840e0b398800f"
    sha256 cellar: :any,                 arm64_ventura: "9a81b11fb722d3669e14714ff370ba431e24fd5bf2edea1dd1fb1f99d0cbf437"
    sha256 cellar: :any,                 sonoma:        "37d8205558e02e48e3da8becd1ece2d815e051c5a5f83d5a44eb09fc9de347fc"
    sha256 cellar: :any,                 ventura:       "9207efe9cc5e7afc622bc5223540ae13bb01c45b21d1718a87945878f704b5f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "456a18ca2750456e3a9f6f3513bf7a5340593e6e11d43d14344c4510084cab27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85fcbb9c7bf5d5478e625c00691eb5638881b5a4464d94a578b9e90f77dbbc37"
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
