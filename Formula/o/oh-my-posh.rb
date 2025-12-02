class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.1.0.tar.gz"
  sha256 "ece79b5b65629cde224676c245597716fd2314c8ade3d3e42955a9bcf1eff302"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08b5c2784bae5fb2ccadf0d00fe140ed5b9d43dfbf95a3eee76ad9c043299306"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6ee49af2fb4cd8641e90386b8b783ff9cb9d87d1739cf84f5214b3b5acbc350"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37ddc246dff450a0c382e1d2a594ff9c1b57e1458eb917e44700cb01217ee7d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e894ff284283446d7c6356539cc8c7914d8c031aaa64c12c89d9cbc4a60c46e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bff927479964afcaac4b77bb117508703ec5a375a5e599d16c58c464477f4df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ca7ae7ec2ee83d126cfdfcdab7e0e2f7e7b4bc292a7668863cb81718c3b4a71"
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
