class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/hrydgard/ppsspp.git"

  # Remove stable block when patch is removed
  stable do
    url "https://github.com/hrydgard/ppsspp.git",
        tag:      "v1.11.3",
        revision: "f7ace3b8ee33e97e156f3b07f416301e885472c5"

    # Fix build with latest FFmpeg. Remove in the next release.
    # See https://github.com/hrydgard/ppsspp/pull/14176
    patch do
      url "https://github.com/hrydgard/ppsspp/commit/8a69c3d1226fe174c49437514a2d3ca7e411c3fa.patch?full_index=1"
      sha256 "1ae7265d299f26beffcff0f05c1567dcda6dd02d1ba1655892061530d5d6c008"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "e2fbd7a06918037ba8d7cd4cd63aac2a91da169109846858d289abf2c506dbea"
    sha256 cellar: :any, big_sur:       "1fb64f1bf453622476e94460904d4f033e05f42755d3f6793775233e9a55dec9"
    sha256 cellar: :any, catalina:      "9b375483a60f6e4e631c5c01a0f5b69c15ff69570749d31f0af77014a6e2c373"
    sha256 cellar: :any, mojave:        "6d22974f4e46d094860b1b1de2ed5b1d9a77e41ae777519fe77e8172fc1ada54"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "glew"
  depends_on "libzip"
  depends_on "sdl2"
  depends_on "snappy"

  def install
    args = std_cmake_args
    # Use brewed FFmpeg rather than precompiled binaries in the repo
    args << "-DUSE_SYSTEM_FFMPEG=ON"

    # fix missing include for zipconf.h
    ENV.append_to_cflags "-I#{Formula["libzip"].opt_prefix}/lib/libzip/include"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      prefix.install "PPSSPPSDL.app"
      bin.write_exec_script "#{prefix}/PPSSPPSDL.app/Contents/MacOS/PPSSPPSDL"
      mv "#{bin}/PPSSPPSDL", "#{bin}/ppsspp"
    end
  end
end
