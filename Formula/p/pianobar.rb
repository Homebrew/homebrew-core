class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://6xq.net/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2022.04.01.tar.bz2"
  sha256 "1670b28865a8b82a57bb6dfea7f16e2fa4145d2f354910bb17380b32c9b94763"
  license "MIT"
  revision 3
  head "https://github.com/PromyLOPh/pianobar.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?pianobar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dfecf674a95a0dfcdffe9d0faca825d61e4733c4f9cd9b41a2bfa75635209783"
    sha256 cellar: :any,                 arm64_ventura:  "ee7d2deecd2fa234a9c14882d25d2828d061de6f5c8b8bbf338a9b97ae040d4b"
    sha256 cellar: :any,                 arm64_monterey: "6332b45b23dfbd4839745039b7a09150874bee615adba4224407f3e0aa8269e2"
    sha256 cellar: :any,                 sonoma:         "c781c81b0ac0e187fef19df756e1ce51a49ff3aa76c6a208e5300e9d23cca031"
    sha256 cellar: :any,                 ventura:        "770e8282379b54adf9e896a90d8ad8bb79595f550117761c27965a5a521e8157"
    sha256 cellar: :any,                 monterey:       "fe84dfc4bb620a7eae6f8aef7d92b5430349d20cae0fe4aaef0d5a0b6e8afa8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0bb0c852528eea565637f7859abd86792173da3161ea88390b9ddf05638f760"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  uses_from_macos "curl"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  # Fix build with FFmpeg 7.0.
  # Remove when included in a release.
  patch do
    url "https://github.com/PromyLOPh/pianobar/commit/8bf4c1bbaa6a533f34d74f83d72eecc0beb61d4f.patch?full_index=1"
    sha256 "9ede8281d2c8a056b646f87582b84e20d3fc290df41c6e93336f90729794b58b"
  end

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
