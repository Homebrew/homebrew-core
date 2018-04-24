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
    sha256 "91345bf4926f09e945c17fd67001b1c5dd59854cc8e24d31c591569109390d05" => :high_sierra
    sha256 "2effbc91ee8b7c51fb8b27623d72709842b0c365ae6dd196a07c7c869fdb1801" => :sierra
    sha256 "b503bc5d9fbcdb6090fbb5c86ddd3d5bbd288e7c8a5121ac23f9b10a0ddc8bf6" => :el_capitan
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
