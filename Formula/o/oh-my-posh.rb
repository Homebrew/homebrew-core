class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.16.1.tar.gz"
  sha256 "e57ac5d43f459f9f0c2b101561c442f88895023bfff5dbd7a8750d632e7a31e6"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "589ccc309ca696f535ee05cc55a487ef71775a525b8d32c8d3572583867e2fd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62b6f6463dddccfd89a25b2dd7cb77cac6713f8e08193ecdbb68a70c9c6b3c7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbd9394da14ea20cedace255d56c7d8112b849c0c0d3076e0c1826cf20bc680f"
    sha256 cellar: :any_skip_relocation, sonoma:         "766aa5e60b9ea247f9ac5e0e28ef2b34796a3939f2841dcaceeba101ca3c6d5a"
    sha256 cellar: :any_skip_relocation, ventura:        "ebaf16bd73ec1092646b69d7b899304ce22d010fdbeada9f4af0ed5613abd2de"
    sha256 cellar: :any_skip_relocation, monterey:       "e239184e7ff631e686ac228f95545e9371c9def3e189c365c23f5d65deafc747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86eb1ad698c2e8287e9f5b0669dc1c6cef3312cdc119944c1763fa8ef80506e7"
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
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
