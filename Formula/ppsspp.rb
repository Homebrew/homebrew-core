class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      tag:      "v1.10.3",
      revision: "087de849bdc74205dd00d8e6e11ba17a591213ab"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  revision 1
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    cellar :any
    sha256 "61164c952a552c94c384ba618b429e8725d812142b58e55c02b89962ce8b28c2" => :big_sur
    sha256 "637651f2a60d63b33d4944fb075b8e8a564a4a0b94ce824ccf0ba69b6d101f88" => :catalina
    sha256 "ef1850d442ed09bdec54ace53e6bedf2eb081ca3da4d2ca9fba91293a98f0f6e" => :mojave
    sha256 "a42d7af34d1aab6f25345aec6711fccedad54fd506eb12947c7c6c8b7e095a55" => :high_sierra
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
