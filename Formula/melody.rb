class Melody < Formula
  desc "Language that compiles to regular expressions"
  homepage "https://yoav-lavi.github.io/melody/book"
  url "https://github.com/yoav-lavi/melody/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "812f058c60eba281758288d14f7a605d5684995b12a5598da73cb49d840eeda4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e33fea76f7857c0589a577399d2e9a0aeca4eca9454d03b66d7b2cad895435a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97f5b61e1bdbe5215ffd9bfe88030a0ae161e9be4da581ea0f9ee956f82b286c"
    sha256 cellar: :any_skip_relocation, monterey:       "72fbd456c97dd04a91ff84b4739b669e45c83d91edb44fda322a6a28f8d56bd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "10897106f499e9351b6b603c48948477e61c2f52b42cf36c988675b41b515c9c"
    sha256 cellar: :any_skip_relocation, catalina:       "abf7c12669405850cf096044c66edf925771ddc22416dc17706fb3258c797d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "749786b2af2d85999323bc050084c7b39ebd06965311c60608c3b342f4ce3424"
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
