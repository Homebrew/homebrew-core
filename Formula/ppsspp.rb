class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  revision 1
  head "https://github.com/hrydgard/ppsspp.git"

  stable do
    url "https://github.com/hrydgard/ppsspp.git",
        :tag => "v1.5.4",
        :revision => "a1e74d0d4f89ba3fa2d4fe64bac7a0fa16fc146f"

    # Remove for > 1.5.4
    # Upstream commit from 22 Apr 2018: "Fix build with ffmpeg 4.0"
    patch do
      url "https://github.com/hrydgard/ppsspp/commit/70c54a7d1ab15c0cf84a205b944db7e0339242e0.diff?full_index=1"
      sha256 "ed7401010e1f1e222bfbb0f1b5321821ce8b780a6781a7928397a09d8807fcb7"
    end
  end

  bottle do
    cellar :any
    sha256 "188fba0108fb2399d66a6339716096d5ff44267fec831a2d617f484a0cfb7dd8" => :high_sierra
    sha256 "7d1ca5e3f63fa206e65f529ef35c7cdb8763fdab849653750ead94d9cbd044c1" => :sierra
    sha256 "3b0923d51f0ca7f5552eb974e9c438aecce0e5724dda9fc358bedc4229ba7575" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "glew"
  depends_on "libzip"
  depends_on "snappy"
  depends_on "ffmpeg"

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
