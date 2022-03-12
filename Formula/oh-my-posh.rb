class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.36.1.tar.gz"
  sha256 "e007434b1af0c5ee747d21805d3a97051a65abd32661139aa50b117cc4f40ea5"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebddc840f787325f58631ce3acf8941b5a2be75a00e12f90b146cbc30957055b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d50313db57aada6fe8e28447f7c19c035cc8e7ef338997a7ca069b59af6c911c"
    sha256 cellar: :any_skip_relocation, monterey:       "17d42cde63d1e9b68b8d99952ab184f59856e14beba008dd38e39ae83463541c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bd07c15d1ceb8da72f74eb51828b80cc3a6632bb06120eccc4b0c78b851e5fa"
    sha256 cellar: :any_skip_relocation, catalina:       "d5997e98ccd62b287b520d673ca9320b04c00226de78ce92dad498627cb54c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3299f297580014af10f36327c75d3c3e7b68529bd93f712a05df8a317e0eb491"
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
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
