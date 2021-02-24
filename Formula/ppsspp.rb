class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      tag:      "v1.11.2",
      revision: "acd496b6c2e9340bf56faf0811863e0aa045107c"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "900c2debd4f74d4d47a05d11ebd7cdce883871309db0fa891f1f02f9e1465425"
    sha256 cellar: :any, big_sur:       "dd09c244a87566c74855c0f17c020f297a561d7deb043bcaad47fac905dc484a"
    sha256 cellar: :any, catalina:      "56bf501a2c69b0b778df5d05cfda6d1e07293dde51cb29f4ca83914efd852715"
    sha256 cellar: :any, mojave:        "4697af74328830e185514d2201b83683fd88b77975b4e72a8a36ac70e0f3a50f"
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
