class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2020.11.28.tar.bz2"
  sha256 "653bfb96b548259e3ac360752f66fdb77e8e220312e52a43c652f7eb96e7d4fe"
  license "MIT"
  revision 1
  head "https://github.com/PromyLOPh/pianobar.git"

  bottle do
    cellar :any
    sha256 "849b8cc567a95e0f91441dd8045567681f697cc8567baa5abcc72f2abe26504f" => :big_sur
    sha256 "1a73d54145ec3a65a7677b1cc3038fc596f06c0ed9157f8581dc08a86d455f42" => :arm64_big_sur
    sha256 "e61e802a0ef161583c808d017b7652e93ba618b6d64314fb391b30a1dba3b86e" => :catalina
    sha256 "57d781b3c9db03c3d91147d8ac19a4c8222756765d96921a53213b8845faed64" => :mojave
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
