class Pngcheck < Formula
  desc "Print info and check PNG, JNG, and MNG files"
  homepage "https://github.com/pnggroup/pngcheck"
  url "https://github.com/pnggroup/pngcheck/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "a24ac2348efca5895e9d6f53fd316f3d5c409ab92a74b2b8106541759304da53"
  license "HPND"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06f4655ebdc1cb9a83d502e514cfcd8c5fa108984ac7e9536e117b3b6978a471"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de3eab5fa5af3e288a31c498cb0f3778efaae124ffc636570e5bf7e4d0c09b39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bb15db528179e648131862326e6f02e0e777f2c38333e51e2e006858a70048c"
    sha256 cellar: :any_skip_relocation, sonoma:        "637dc8b986af16b9f14fadbfd3fd9baa9ad3d7cba8301c046ee28cd78ab0186e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fafce573ad3a6f08c1a64f544af99c62b605eca2d3fc65f3e9fbe955f968dde8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13b68192c37d494a1180cb2cdd43995796b1f314075e5c045d35c653c407f65b"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Remove files only needed on non-Unix. Doesn't need to be removed as CMake handles it
    # but they have different or dubious licenses so let's be explicit to prove that the above license DSL is correct.
    rm_r "amiga"
    rm_r "third_party"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"pngcheck", test_fixtures("test.png")
  end
end
