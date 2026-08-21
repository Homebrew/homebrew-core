class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://6xq.net/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2024.12.21.tar.bz2"
  sha256 "16f4dd2d64da38690946a9670e59bc72a789cf6a323f792e159bb3a39cf4a7f5"
  license "MIT"
  revision 2
  head "https://codeberg.org/purplesym/pianobar.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?pianobar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f62296d8fd71f82628da75780e6edba714b3f197024aacb199598cd8d5a483c9"
    sha256 cellar: :any, arm64_sequoia: "3ee33cd45467567f4b13581d585dc9aeea78077d9e2232d1bbf7b2f8f4e8663e"
    sha256 cellar: :any, arm64_sonoma:  "32c9084f2530fb219fafc611446114ac01aae44b8017e6946eed06e130ee7bdc"
    sha256 cellar: :any, sonoma:        "96928b379daef40b553ca121a8b24ba318ea46ef0f4cd250e57cd68424acb626"
    sha256 cellar: :any, arm64_linux:   "c89e6573dc346c6cff24d6774f28be820baca79c66db9d4c270ddd6e54d76f3c"
    sha256 cellar: :any, x86_64_linux:  "721f7c74b50b6f0b2531c9bf180749602d038dcdd11a1154919149dadf1a36f4"
  end

  depends_on "pkgconf" => :build
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
    assert_match "pianobar (#{version})", pipe_output(bin/"pianobar", "\n", 0)
  end
end
