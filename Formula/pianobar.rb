class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2018.06.22.tar.bz2"
  sha256 "946357718a7b5fea661247ad10187e77f94724ef2bb29a2482afeb2d8c8bd4c2"
  head "https://github.com/PromyLOPh/pianobar.git"

  bottle do
    cellar :any
    sha256 "d4478a5404a4d912f512978420f66032ee5b094cdd970c9734877ecfe53165b3" => :high_sierra
    sha256 "e6006ef98f2a44e0dfd3ec57835bf955063165cd50d1b2ba0f9a50a2cf31e7d9" => :sierra
    sha256 "245e0fe8ff65bdb42356eb8a887a8df40c391a6fe8ee2e8d7f32bb110538392b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "mad"
  depends_on "faad2"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "json-c"
  depends_on "ffmpeg"

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
end
