class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2019.02.14.tar.bz2"
  sha256 "c0bd0313b31492ed266d1932d319cfe2a4be7024686492c458bb5e4ceb0ee21f"
  head "https://github.com/PromyLOPh/pianobar.git"

  bottle do
    cellar :any
    sha256 "0e9129214de23a285f6fbe90ee3a078435fa74d86a0b0890bd89a466283edcda" => :catalina
    sha256 "f8e2e06461658017ffa0cc6a6c06d49cfed91cbf359b7d23875512e657fd027f" => :mojave
    sha256 "aee9b756146a2440ea1c370b11d165088a68d733bf17be413232a88106e8df6f" => :high_sierra
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
