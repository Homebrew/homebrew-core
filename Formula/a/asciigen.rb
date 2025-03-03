class Asciigen < Formula
  desc "Converts images/video to ASCII art"
  homepage "https://github.com/seatedro/asciigen"
  url "https://github.com/seatedro/asciigen/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "b5cbc1dadadf43b1c85a4c2171c8dc1dcb9e1688812a773139d01dda821265c4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "de0e9f335659384facc45dcecc8d00f88d6d32629da49ed68d22b030c022bf39"
    sha256 cellar: :any,                 arm64_sonoma:  "8bac5ecbaf7380d8d153eca5b8d82c410398fd35c4e5d851606b627cbda2b120"
    sha256 cellar: :any,                 arm64_ventura: "e7542f752cce0ead8b5f804923538ec21de7b8470a3cc561f32b26d71b8c8405"
    sha256 cellar: :any,                 sonoma:        "bd7fe2ed34849bc43595514f9db6be770a89c6e7c28e62320220090547946d2c"
    sha256 cellar: :any,                 ventura:       "d0520804e71a9eee3d721cd973636008d2bc422f55796bc87374da368e6e6528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b97b03015d85f6463ff7e903928036e2f7bd7446712c13d2f3dda4e05eccc933"
  end

  depends_on "pkgconf" => :build
  depends_on "zig" => :build
  depends_on "ffmpeg"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    system bin/"asciigen", "-i", test_fixtures("test.jpg"), "-o", "out.txt", "-c"
    assert_path_exists "out.txt"
  end
end
