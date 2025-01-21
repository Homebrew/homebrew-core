class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.18.1.tar.gz"
  sha256 "ddd91c86ad8c29a69e4aa02ede9ae5981c22a917ccf22a956b37b6a8728fcbcb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52f6e336ba91e1da282b22a057943039a24f59440ab4ab22daff49b2b99435e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19c2575d95e4d927a7b95810c7c6d8d46f3e410b33a2de37df5679c768349aa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "467498a5ebfb70ecc120c2eaf411f5de08ad43468bfd48bd7e2a74a6474da263"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a26e2b55bed1f4eff509325f5e202e14a0b68b9a9e14cd64afc98e0dc8d6485"
    sha256 cellar: :any_skip_relocation, ventura:       "d4cd9a4851a51d3b251ddc05b26cd73dde4909ed5e56e32efe0dc025bd05f25d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e00034f1dbc2a73d845e460f59c25b4baa632371ff53f461bea244a756763540"
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

    generate_completions_from_executable(bin/"oh-my-posh", "completion")
    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
