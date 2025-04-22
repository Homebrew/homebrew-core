class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v25.17.0.tar.gz"
  sha256 "f3eca0e4e5d58ef45649602fd85a59be65d172936c0b6f1264ed7779a2c3aa90"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b214d27e9efd9b94074bba8e47b4289381565fcf7acb7d6653ca4d4787f8a89a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfb0f7bf8bc13eb9fe954b7eabf2504245ae8c0712bdb46ca691edee01657fd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2b605a92f061dea5bf81b8da1cceb2e9e496336c8aaa14579fcd207c474f09b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b815e726bacaa16651aa95bf2021fb59e4d64f108fe897c5eaf1c33450ecdafa"
    sha256 cellar: :any_skip_relocation, ventura:       "10039bd23d483c4f7e10ddef5a169e8e28c64f3e221fe34e1c85dc67c4782510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98c9da5a7e3e3b0ceec46da2fb18aa062fcfd3553fefa15f2224edc47e189a3d"
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
    assert_match "Oh My Posh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
