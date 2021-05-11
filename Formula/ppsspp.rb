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
    sha256 cellar: :any, arm64_big_sur: "314da1de23e382d1587f9545c6d500f2a5cc713753afeae69fb9c85f7af85897"
    sha256 cellar: :any, big_sur:       "ea635a5160907cda3af9bc7d723b6b671f5cf2d8702161871eab9c693f936962"
    sha256 cellar: :any, catalina:      "d647d61ef3012f68d537f0221f36fefdac9ae65fe2c98af37a809ef36f8e7f91"
    sha256 cellar: :any, mojave:        "ce1240e0df0217f7f37261419152ab59744f4c77a0ac6f39df025a935abf0620"
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
