class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2019.02.14.tar.bz2"
  sha256 "c0bd0313b31492ed266d1932d319cfe2a4be7024686492c458bb5e4ceb0ee21f"
  head "https://github.com/PromyLOPh/pianobar.git"

  bottle do
    cellar :any
    sha256 "31acde75d154aab53f18d40901b23466ed5d95a3ab08ccb7e1b8922e85d71c05" => :catalina
    sha256 "5b542cb16f0ea880c56e9e6a4e3607b5a3b0c99716948b62d01e259a3ad8bd9c" => :mojave
    sha256 "ae7c37f76393133eb0c89ab71a4d85d3a379a4c83e79fe925627096229218878" => :high_sierra
    sha256 "2482cbc242c836393dfbbe5a586d33dc58899e572aa3e929c9a371ea557071db" => :sierra
    sha256 "d7f002bd258a1423a040e6ed1c78e74ade37f3af1e447e37506ba4af9b658718" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

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
