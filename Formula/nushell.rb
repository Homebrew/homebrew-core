class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.40.0.tar.gz"
  sha256 "fe8a7084cf2962b49144971375b7d07f32ba96fca267b5087d03f298ee53d106"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "941da496a1f8b881e60d73abcde8f779007d71617697b73790ca4bc10a2a9886"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27ead2fd3064df62a4248a1cc916b7b8299f6d898a206613ac688f2fa72a322d"
    sha256 cellar: :any_skip_relocation, monterey:       "1ea28c4f17f1c09f9817618e8bd675f3983b9c5f178e102072dfc67c779f1f12"
    sha256 cellar: :any_skip_relocation, big_sur:        "6527f589c3a876135e74e84ef0f6cfe053fb05f78954c8b2011f96aaffbb2e68"
    sha256 cellar: :any_skip_relocation, catalina:       "e4c1d2d9d3e5f32ffe14d6a68d463f5e5c7ad4d4daabf765537209b8486ce616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5096a8408ac43e0b884b7a4c01f50fc3c61796b3116e57acbbe57a026d00884"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar" : "homebrew_test"}\' | from json | get bar')
  end
end
