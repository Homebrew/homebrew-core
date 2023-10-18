class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/releases/download/5.3/MrBoom-src-5.3.tar.gz"
  sha256 "75c3812878809c908094416b0d50e8b380d158d0ad12b9ae6a9a95ab926866c1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cdaaa2a50c27d99e9d66601ebd40897dc14e019b2def57077d2484af8297112c"
    sha256 cellar: :any,                 arm64_ventura:  "d7812215deb1254ac2b4003ee0182d4ec03ae45f81c4d9f41d627efc8dff65f2"
    sha256 cellar: :any,                 arm64_monterey: "5098c3b755f663af968243251760fe3a39ce38c4af256959df60fb09f12c82a2"
    sha256 cellar: :any,                 sonoma:         "5a083da53a4c1a630b5c8b77cf8fb95572aa319caebd179bc0b285175df3ef91"
    sha256 cellar: :any,                 ventura:        "e7080fdad61d206f0ab52a03d09c2e7a53347bed66e6f4993530ccbdf96d8c87"
    sha256 cellar: :any,                 monterey:       "7009374a1fb96c001f1cffb96e08c004455b4e114670c906c82e78f8c01853ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf114b335c1056c8e6a1e94cb4eab46974c84ef2c8f2f5521440c46d5b36bc82"
  end

  depends_on "cmake" => :build
  depends_on "libmodplug"
  depends_on "minizip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  # Remove in next release
  # Fixes: common.cpp:115:10: fatal error: 'SDL_mixer.h' file not found
  patch do
    url "https://github.com/Javanaise/mrboom-libretro/commit/d483c2dc308ddaf831fb81bff965a1bca266b7c8.patch?full_index=1"
    sha256 "573f11c68b97190398f7f0bcb3338c6f387bf4be39e4fbd3896278b611d0cf59"
  end

  def install
    system "make", "mrboom", "LIBSDL2=1"
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=share/man/man6"
  end

  test do
    require "pty"
    require "expect"
    require "timeout"
    PTY.spawn(bin/"mrboom", "-m", "-f 0", "-z") do |r, _w, pid|
      sleep 15
      Process.kill "SIGINT", pid
      assert_match "monster", r.expect(/monster/, 10)[0]
    ensure
      begin
        Timeout.timeout(30) do
          Process.wait pid
        end
      rescue Timeout::Error
        Process.kill "KILL", pid
      end
    end
  end
end
