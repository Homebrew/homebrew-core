class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.3.5.tar.gz"
  sha256 "515cee6f571ac527f7ae877525211d87cf9aabb9bd4392f4ddab2cd6c44e1ad9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bba0f9f2bdac2aaf245ac8d6978b99d445aa05796f5d3a27ac2a26bf746475f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc0ebebeb29f67032942741a257524b9919b03963ef12a7b89f644a15d0053ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dc93aa82c544fc0442bbb8ce1660c20969ead2b4107893faf27c0821f13674f"
    sha256 cellar: :any_skip_relocation, ventura:        "b696b348a62985e1959107a24a75921dd3d97f120ce8b8866110a40108747137"
    sha256 cellar: :any_skip_relocation, monterey:       "d86c9d9d16096c716900173589a8ba81665b186b7af49de68e47998073b06f7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "eefddd7a217774ac4c9cfaaeac030566818ba9b010deefaec4562f593525395a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a0e7451cbae5009e83ec208ce4f4e20da65057777ba48648ea01789a3a43c54"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
