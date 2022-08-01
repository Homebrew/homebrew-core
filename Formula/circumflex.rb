class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/2.2.tar.gz"
  sha256 "6a2467bf6bad00fb3fe3a7b9bdb4e6ea6d8a721b1c9905e6161324cfb3f34c01"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16ca677cc0336d37cec75b9436f82315bb1cb48b8af0524bd68d157c6828b48d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "035994e6fd161bd14934ae37ee28dc34d6f04a0eec2169d097a599a4169549d9"
    sha256 cellar: :any_skip_relocation, monterey:       "d8eb020f8b63d4f58e1dbf9cb1bc8291f8674fcfbcef8f8368f44a5598afb728"
    sha256 cellar: :any_skip_relocation, big_sur:        "17cbffe48e6937ae19330d2274b1ff084415cad1e9464ad993acbe1cd324cd74"
    sha256 cellar: :any_skip_relocation, catalina:       "f57a7a6866f2bf7a715cfeb033fd6ab549b61b85a00eb02d1dd0cd24dbe3ae07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4300b5f392b98a629b9648ec2d61a11e7aabd9f74e69c059dcd4fb41a922641"
  end

  depends_on "go" => :build

  # Requires less 576 or later for --use-color
  uses_from_macos "less", since: :monterey

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx view 1")
  end
end
