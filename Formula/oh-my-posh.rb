class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.34.0.tar.gz"
  sha256 "2d0e3dd63bcf53b5785b5457d46e29dc633fe0c13529815abda55ab6f09a5eef"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e5eceae58d9e0400a653345224fe062049c034031ff83d92c1132746fbc3660"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbd6c86130225624b9124f790f691a9735b65ce1f6cdcf0b7335aa9a17d92b4c"
    sha256 cellar: :any_skip_relocation, monterey:       "6ce1da1bb167cda583287b4a76b8199f1252538aaf62866771ed5ad44d45aafe"
    sha256 cellar: :any_skip_relocation, big_sur:        "9263418a607bb9d002aeed2f514315d54031010ad0c1142c894c1982d9edddec"
    sha256 cellar: :any_skip_relocation, catalina:       "07a7eeb0bb49e498dfd366adac88b0864ace1b15fbd6f01011ca70d4c14596b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e88a519bda51af5cc97ff67eba31a2ab2e8868f9dae6a60b8985f82bc363d183"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
