class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.33.0.tar.gz"
  sha256 "13e766ae3de957e322790cf9874ebc1b768abd205228db7181643e66564c6245"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "892a28b839a2de152633237a0e45bfa9bd635df3beba332221869c5f6ddce7f9"
    sha256 cellar: :any_skip_relocation, big_sur:       "d54c43a2d81d8cf61ee011210451f74cac04b5929db9d153891c0bd080cc95fe"
    sha256 cellar: :any_skip_relocation, catalina:      "d02bb02d4cbae6ce9a5f211cc0cbc0ee4c5de913a08e218dceeaf43120947e37"
    sha256 cellar: :any_skip_relocation, mojave:        "b8716e127334f781821f2e87dbea74c55cfccde0dc5149e7c4dc6c16c1b7f88e"
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
