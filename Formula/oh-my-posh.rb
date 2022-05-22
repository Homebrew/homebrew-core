class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.88.1.tar.gz"
  sha256 "a979da685f0494357153483e94814f7eea9ca2f6c3f1ebf853b20c478d629535"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc569ea3ab83be6292d29192742f8c3798bbbebbeaffffb36d2089bd5fc7e666"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b5bd2e479e4b1fbccc512f5f781ccfd1d19e7fd307dab1169ee69f59e62513b"
    sha256 cellar: :any_skip_relocation, monterey:       "6ae3d368efd1fd063cb4be5b95ed87cdecc51a562f08e9c34ccfd9a2a7670e5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "383f4f0b3da1b4770b10c5bd705e5896e968240e59f29aa61b785d3a9e47cb1f"
    sha256 cellar: :any_skip_relocation, catalina:       "9733771c4b74e9e885c736a51c6f7649080f2fc8bc8bc29c64bfcc7a8b131713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a38a71ec41308f426e8cf8d5c43730109957d5b85d63b79777607512108fd981"
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
