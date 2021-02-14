class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      tag:      "v1.11.2",
      revision: "acd496b6c2e9340bf56faf0811863e0aa045107c"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3c526abf34de1401baa178f9dc92ea8ca3dd6e93e1cd03d8c6c6a05762e0f436"
    sha256 cellar: :any, big_sur:       "3bc377a5ece3958d48f1ac896d0a948d8832c72d7d2a7f06a24c4ae503f57d09"
    sha256 cellar: :any, catalina:      "1fe321b840b818b92c2a494bb8b97d299bfa71b8355919f74e06a7b236c78e07"
    sha256 cellar: :any, mojave:        "4e7814cd39e2089e2fc18b0509557c032dbcf7ff6369f49190d31e3c4cbe46f4"
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
