class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://6xq.net/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2024.12.21.tar.bz2"
  sha256 "16f4dd2d64da38690946a9670e59bc72a789cf6a323f792e159bb3a39cf4a7f5"
  license "MIT"
  head "https://github.com/PromyLOPh/pianobar.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?pianobar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "40becb06f83fe8900cc315c4e17a6f9d2aa0e6c0f64ebfa92c9d4375f0f37822"
    sha256 cellar: :any,                 arm64_sonoma:  "60fbc938432af84fcbd2d65af5a8c7f84a73971953026904e40a72f36ca9916d"
    sha256 cellar: :any,                 arm64_ventura: "b10ac8d07a77bb918559f52fd2b940e1fbb67114821bcc0787f00998343ef32a"
    sha256 cellar: :any,                 sonoma:        "54ece37889c899e13f6a450eaed826b55a02212677e6335f30733bb11dc3ba84"
    sha256 cellar: :any,                 ventura:       "075e6a4aa76b0c0652c66017f8fddb9642b6d4ed5e04686594ff02ea0e2f2426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adcd810b2c11957d38dd073181a1742e0d579a60b61c78228ac21fb2fc9f101b"
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
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    require "pty"
    PTY.spawn(bin/"pianobar") do |stdout, stdin, _pid|
      stdin.putc "\n"
      assert_match "pianobar (#{version})", stdout.read
    end
  end
end
