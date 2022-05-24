class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.1.3.tar.gz"
  sha256 "571f35b2b08d0e0617028854a8c2781b822544c58b8a081f4fc795a779c80878"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32fe8276af7377e261161941bad36afcdeece7214c7a0564c22a6fa88391e2e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f101144681a4224f5d9c629ed147dd82ca5fc18c365d53d3481f3453e743ad0"
    sha256 cellar: :any_skip_relocation, monterey:       "eea28058f927509c462d3ad3f273963c1fd5c41338cb8514a5cd2fbc7e282906"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6e61947df1041c3dc1826278438a1090299317572ef6d35a5d79604bdb1342a"
    sha256 cellar: :any_skip_relocation, catalina:       "4bbda5418ed1dd8a67b18e6a2fa1ea472c392f95a6fd39774bbd09c4bf6dcc56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b30c7f396ba6f4b3a2f7fde014859d2f1f8318bed1c06060bfc34f7ba74b0e08"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
