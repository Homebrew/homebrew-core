class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://6xq.net/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2022.04.01.tar.bz2"
  sha256 "1670b28865a8b82a57bb6dfea7f16e2fa4145d2f354910bb17380b32c9b94763"
  license "MIT"
  revision 1
  head "https://github.com/PromyLOPh/pianobar.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?pianobar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "62be8f8464f1c43ccfc10d69186846ae702da581b774b9a5aaf89672007ef1ee"
    sha256 cellar: :any,                 arm64_monterey: "7c33a6f2e9b9ae1d701f14a520292c89caa7ea330e8211c9987ee391f20618d4"
    sha256 cellar: :any,                 arm64_big_sur:  "530a99e4e0542d8464ae5230de3c45603476d1c6bf8c1a08ffba215959753b99"
    sha256 cellar: :any,                 ventura:        "7899d56fcb01b605d46df7ef679869ee93459307e1b628049caab25a2ad0eee9"
    sha256 cellar: :any,                 monterey:       "6233ef41fd8d56e42636aa74ccb7ef2612f13d55f7117a2fe0241da90f003bd0"
    sha256 cellar: :any,                 big_sur:        "cc1f2870b2bcfd05cd880aec0587fba5208ec42897c1338ae8ea89f8abf713b8"
    sha256 cellar: :any,                 catalina:       "5eba43deaa835d05bbc03636fc3277d7a40120e381ba8ba2430d07ab6d272fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99e93aa0bf38508bc6f7174b91dc72dcf32ee79dbe92d4c6057864b3d8009206"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
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
