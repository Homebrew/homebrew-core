class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.4.1.tar.gz"
  sha256 "be322b010c5c36af41b0a986ddae91588bc4addf0c99748a9055c08831d563a9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76bef0755749c96bfbfa7a8b89712495a98eb8fac431de68c9762a9ea6e826c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "367fe9d6e93fa35f97e867c126b3590b39921a36ac2e732ac741704aee6feaee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "206fc4b0d291d365690f3b3ede70b843b0c072097b938caeddc357904eed94d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "90ee4b213e44e5ac6d25bcdf2da3f209beb46743318f11832b88ac14a8f7cd38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebf0d222bba48b80c9540b784f771842f92f98850fc5d1ca7663f0c9bcb52778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b7d1de0d5df32aed5e5726edf74bc22006dba1b76d3f118fc7e8a25ed2e7c11"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
