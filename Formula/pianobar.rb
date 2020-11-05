class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2020.04.05.tar.bz2"
  sha256 "6c173b6b29ccc1f432e0013fb425e8f9cb4261539b58d344e0b2274963726480"
  license "MIT"
  revision 5
  head "https://github.com/PromyLOPh/pianobar.git"

  bottle do
    cellar :any
    sha256 "3a4af837eda3fd69d0ae6eff3f41bea761af7e9372d13009bb598ab61ec461e9" => :catalina
    sha256 "33bc77940bb9996d514ba4eff59320178c47c49b2fcb196df0003884b3fe1135" => :mojave
    sha256 "d6d817791bc83b0658058ac7cab91aeba8bbec86bf675fc76c69f4adef866a5d" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  uses_from_macos "curl"

  def install
    # Discard Homebrew's CFLAGS as Pianobar reportedly doesn't like them
    ENV["CFLAGS"] = "-O2 -DNDEBUG " +
                    # Or it doesn't build at all
                    "-std=c99 " +
                    # build if we aren't /usr/local'
                    "#{ENV.cppflags} #{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    prefix.install "contrib"
  end

  test do
    require "pty"
    PTY.spawn(bin/"pianobar") do |stdout, stdin, _pid|
      stdin.putc "\n"
      assert_match "pianobar (#{version})", stdout.read
    end
  end
end
