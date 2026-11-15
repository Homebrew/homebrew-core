class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.hugeping.ru/"
  url "https://github.com/instead-hub/instead/releases/download/3.6.0/instead_3.6.0.tar.gz"
  sha256 "ecc15268824d4cbd1d56ba4e44491069accaebaa642a6d275169878492ede80b"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "86219e7e5aca92b1a1d4b8f639d1946232d2221e527b749f49ba407e533d2452"
    sha256 arm64_tahoe:       "7d0732d392fc927db7d778ea935d92d2e0c12de4286b8b3bf44f5a93d12a5a7e"
    sha256 arm64_sequoia:     "cb326b3adb5f8d7f31bc7e7a4cde8924a47cdd0c7e3c7f65420ca73fa2eaca57"
    sha256 arm64_linux:       "8612458c7ecc9521efeaca057ea01660529bcfe107e9757a957fb05024a282e2"
    sha256 x86_64_linux:      "899c00dc314cc1d7aa40732c86d50f6e1e1c338fdb901db9ff9b9ed18c388f45"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "luajit"
  depends_on "sdl3"
  depends_on "sdl3_image"
  depends_on "sdl3_mixer"
  depends_on "sdl3_ttf"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DWITH_LUAJIT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/instead -h 2>&1")
  end
end
