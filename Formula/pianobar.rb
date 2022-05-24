class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2020.11.28.tar.bz2"
  sha256 "653bfb96b548259e3ac360752f66fdb77e8e220312e52a43c652f7eb96e7d4fe"
  license "MIT"
  revision 2
  head "https://github.com/PromyLOPh/pianobar.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ba9ac1b0f24fb28d3e6e3a03f715504054759559cae549df46c5a804bdaece8a"
    sha256 cellar: :any,                 arm64_big_sur:  "00b8027107c1afba4dd0c91edc602bb885ea4ae970c007eb92fd811403976ab5"
    sha256 cellar: :any,                 monterey:       "b8f5b1ad1c8457131c871ae68dd363ea8e8b0791fbfa3d070de77cab8d09d495"
    sha256 cellar: :any,                 big_sur:        "5dbc24f0e6718770b02c87bdf1ed8ad4010960a659e85a63714df0ed317d3d73"
    sha256 cellar: :any,                 catalina:       "f7627970b36ad2570186a6cde16f349de3e80c57fd4f6a30d59be2479da63df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0fb3f1818c95bfe5ab201277b97f441a3673a65127bd335bec780542dc09e04"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  uses_from_macos "curl"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

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
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    require "pty"
    PTY.spawn(bin/"pianobar") do |stdout, stdin, _pid|
      stdin.putc "\n"
      assert_match "pianobar (#{version})", stdout.read
    end
  end
end
