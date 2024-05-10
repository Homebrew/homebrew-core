class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://exercism.io/cli/"
  url "https://github.com/exercism/cli/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "e25f85e80c517551a6cd55a5289af3caf2819356601ef907339f82aa8145f004"
  license "MIT"
  head "https://github.com/exercism/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0889f27ef41b7426ff1e15359160c70c7be0f39e423dcf25cd12a9589675be08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27b8fd95991f2477614d3ed65f1e1b791f801d46400cadb69b1c482bb634f6a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b484c7de5f941af470dbbdc141647c4d143f395ddae3e71107d2894201da0995"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ec25271cc46405436941b94187119f7715989c2ba373a24e1b6733bbe575126"
    sha256 cellar: :any_skip_relocation, ventura:        "3640b3df7dee3b70510bb742377a5018fe2c1dc967da365f674bac678fcb8c16"
    sha256 cellar: :any_skip_relocation, monterey:       "a82275f8d9c81fb99fa40df3753bb08d8afb3ea35b03f2cf6c1a2bcd1c55f3ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0acb3e9e52469e86aee23bcefd7be430d144336476343de6abb14d095a51e22"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "exercism/main.go"

    bash_completion.install "shell/exercism_completion.bash"
    zsh_completion.install "shell/exercism_completion.zsh" => "_exercism"
    fish_completion.install "shell/exercism.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
