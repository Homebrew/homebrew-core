class Basefwx < Formula
  desc "Hybrid post-quantum and AEAD encryption toolkit for files and media"
  homepage "https://github.com/F1xGOD/basefwx"
  url "https://github.com/F1xGOD/basefwx/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "9084a7678aedc52bc2fd954dc78a6f43150dc5dee2bff45b28af36e408e94f3d"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "openssl@3"
  depends_on "xz"
  depends_on "zlib"

  def install
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DBASEFWX_BUILD_CLI=ON
      -DBASEFWX_REQUIRE_ARGON2=OFF
      -DBASEFWX_REQUIRE_OQS=OFF
      -DBASEFWX_REQUIRE_LZMA=ON
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
    ]

    system "cmake", "-S", "cpp", "-B", "build", *args
    system "cmake", "--build", "build", "--config", "Release"
    bin.install "build/basefwx_cpp" => "basefwx"
  end

  test do
    encoded = shell_output("#{bin}/basefwx b256-enc brewtest").strip
    decoded = shell_output("#{bin}/basefwx b256-dec #{encoded}").strip
    assert_equal "brewtest", decoded
  end
end
