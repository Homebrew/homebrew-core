class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/v0.5.12.tar.gz"
  sha256 "41bbcbde13c3a27696cb4ac0b9e752a925661747acc4075450e10d4e17b17bde"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b75a6c4b6186088ec112ea402745b5b3f98c0403db119b3bdb3a44f86efe205a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9109df57981d90223868a1c3339d2202c312f463dc100a4d8732621a21dfa84"
    sha256 cellar: :any_skip_relocation, monterey:       "d166de1dde689c2df29035667e101f0139eb23a59dce69a0ceca02fb8fee06a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f2a08a6e2bdb25ff33cc29eaaa46218bab4604d4e0b1ed89576f864010946a1"
    sha256 cellar: :any_skip_relocation, catalina:       "7fb0ba37f9ea3264afa5d288880b803185683fefe58d6f0eecccf9261024bede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a39f923facb47f83f2045532e0555fc554bd9f21f1bd1b2c5bf4407fdc89b67"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}/mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}/mcfly --version")
  end
end
