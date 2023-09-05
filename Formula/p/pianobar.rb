class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://6xq.net/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2022.04.01.tar.bz2"
  sha256 "1670b28865a8b82a57bb6dfea7f16e2fa4145d2f354910bb17380b32c9b94763"
  license "MIT"
  revision 2
  head "https://github.com/PromyLOPh/pianobar.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?pianobar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fbc2fd420f260620ef30d57b13d850df8da77b2dccecb53a5fb9d698089cba76"
    sha256 cellar: :any,                 arm64_monterey: "4e6349ecff466a1e973fa0975e992ae0db11a4f919a535839117fda07b402158"
    sha256 cellar: :any,                 arm64_big_sur:  "0c642308962498b47dae7eec94f52245daf878b180ad5157c107d5d3bb200f75"
    sha256 cellar: :any,                 ventura:        "abb8bf92074313509c45f27760b1f7c48b7cac98b6cefb82a8eee3c413f1ff1e"
    sha256 cellar: :any,                 monterey:       "9b479699fb6c58fec10367f6062613ace2697cbb4d9fd5e64257c83fb182d0c4"
    sha256 cellar: :any,                 big_sur:        "5ea04fcbbc9d9f411a08f6929fb3c9f12d0e09f1b5e4c7c1d695f3a6151126c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44018c075406e5c40822a95155d287dcd13541f27048c566bb5c2fd8edc43b29"
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
