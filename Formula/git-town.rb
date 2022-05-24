class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/v7.7.0.tar.gz"
  sha256 "edc4f87ef904ac297b9fbb30014e2ab474ee633c1687ed5011b38cd6f8b950e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b895a2527cb025670bc0785bc1979ee37ada8e5debc666f33495487518320ae3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0653a75795037279e493bcdff33c72e53697cc5d505867f6dd967420bbce45c1"
    sha256 cellar: :any_skip_relocation, monterey:       "47cc3cddd23eb6a28920f94f3334cd521f35d4a9a504df3c9ffd46d158903a1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0eb3a68dbe09af790dffe7f9651b754fd080e731f5cf16a2e6c2eaecf49dcce5"
    sha256 cellar: :any_skip_relocation, catalina:       "0a9df8537d6eda035c7ef2901c15cdcf80f8eb4471081c57864bca984c559ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "773aa43c7bdb8760f05dad469b016a091a74ab9a2321e22a01a1cc180cb8ea03"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v7/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v7/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    (bash_completion/"git-town").write Utils.safe_popen_read(bin/"git-town", "completions", "bash")
    (zsh_completion/"_git-town").write Utils.safe_popen_read(bin/"git-town", "completions", "zsh")
    (fish_completion/"git-town.fish").write Utils.safe_popen_read(bin/"git-town", "completions", "fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town version")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
