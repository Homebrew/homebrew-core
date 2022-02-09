class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.44.0.tar.gz"
  sha256 "94bb003fd05b604a174a686c40286fef460bc06616a7d273c387a54a07576ecc"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fd1cf91545339da414b6c5d28deb6decec46fc9d70ce60e704d453d9c6e5c35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e9da5c5697a65e845ca1c155f55b143e74e2df4dd6d13d0ec8bfe9eddeb0a73"
    sha256 cellar: :any_skip_relocation, monterey:       "cdaae79a20e32787380660663f1d0594c1f965b5c000832e26283f39b9feee13"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ea5fc604ea1a7ae555403ae98127a365d4364731c1cb716139f5fb90859569e"
    sha256 cellar: :any_skip_relocation, catalina:       "28d8f5ff90381b5d65584e5defc702a3586f42c2d8d5d83df6c2eee9832e42e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76d019423b8f4d41bca9fa15c9df16e7ce4636af993e73260a461ae667ba0bfe"
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
