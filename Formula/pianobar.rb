class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2020.04.05.tar.bz2"
  sha256 "6c173b6b29ccc1f432e0013fb425e8f9cb4261539b58d344e0b2274963726480"
  revision 1
  head "https://github.com/PromyLOPh/pianobar.git"

  bottle do
    cellar :any
    sha256 "72960248085d1258e84a2d864bff4a93f0b4f16aac3f8dff3a9d593fdcf0244f" => :catalina
    sha256 "8169c7859a1dc35bd9c7eb1d353517fed364511cf875477d321b0e20313f665a" => :mojave
    sha256 "e397752de16144f63aaed8e1341a602ee5ca5e4f7f02d5669091ecae1f8f02c3" => :high_sierra
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
