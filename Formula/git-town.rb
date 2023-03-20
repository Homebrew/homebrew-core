class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v7.9.0.tar.gz"
  sha256 "316002e79bb60bb0ef694720c3c220aa543d21abcd9bacb604d7209d66629ffd"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34ca3abf4c2fc343a84f8936af247e0db68c7899297337993827b9aba7318a00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "068dd9c640d693737a9fdca9e2822b8d1f147e108a8e17652bf1585446c5490d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "effd49326a8bbdd6d8d07764ff636bdc849370d1fd00f09caee486b67d0b993f"
    sha256 cellar: :any_skip_relocation, ventura:        "3e8166c9f8e7ef48a68b6e66670e5bac25bdfe74cebc87796f4437942d96d068"
    sha256 cellar: :any_skip_relocation, monterey:       "1ea65dfc01d5a02960a5db3ad1fcd01407086be7c6461c7132d80a5def194d59"
    sha256 cellar: :any_skip_relocation, big_sur:        "72b198274293f8175e535c7f2d2b9e72d87b55f17f1d6984ccd469b1e8083796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c53448de9c489c6d4b8bfc33c7bcd021e12fa8adbe0f2924bef9106449e24f2"
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
    generate_completions_from_executable(bin/"git-town", "completions")
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
