class Melody < Formula
  desc "Language that compiles to regular expressions"
  homepage "https://yoav-lavi.github.io/melody/book"
  url "https://github.com/yoav-lavi/melody/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "c68c05c0d87d4ab1069196f339043252fb1754395d8e5504f5295a2fadcc51d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f814ba14939959f4db8a8f4c983f2889d61da637c5b07c1bd2cd1102be4eebc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38d60a813a8a7c3697d207adafd0fdeb51f6c170b5f5bc15f1ad07b70676d991"
    sha256 cellar: :any_skip_relocation, monterey:       "15d783b6c4f97ea55f6ba74329566a1d62f6bf1d9e7daa792ed53bfd3172288e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a25ec8fe71351c002003dd589f3eb747095744adc4f094c994a562ac92710c5"
    sha256 cellar: :any_skip_relocation, catalina:       "7729fb554495e55258a80723be572595b68a77f10bb97a7a40cfb7803a0d3836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebe39d3d00ad6bcdeb3874907202bf8289f5f8862cdeb736a9d50bc63abf7e64"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/melody_cli")
  end

  test do
    mdy = "regex.mdy"
    File.write mdy, '"#"; some of <word>;'
    assert_match "#\\w+", shell_output("#{bin}/melody --no-color #{mdy}")
  end
end
