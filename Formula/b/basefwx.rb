class Basefwx < Formula
  desc "Hybrid post-quantum and AEAD encryption toolkit for files and media"
  homepage "https://github.com/F1xGOD/basefwx"
  url "https://github.com/F1xGOD/basefwx/archive/refs/tags/v3.5.3.tar.gz"
  sha256 "cd24749ac76dccc788dff493bf6b96a58dd7c740167e67cfd7467c13f6e7ec5a"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DBASEFWX_REQUIRE_LZMA=ON
    ]

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--config", "Release"
    bin.install "build/basefwx_cpp" => "basefwx"
  end

  test do
    encoded = shell_output("#{bin}/basefwx b256-enc brewtest").strip
    decoded = shell_output("#{bin}/basefwx b256-dec #{encoded}").strip
    assert_equal "brewtest", decoded
  end
end
