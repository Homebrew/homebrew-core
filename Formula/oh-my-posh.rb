class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.59.0.tar.gz"
  sha256 "055d29652992cf9d529016d24396d527ee2e9003e3310a51741bdb07c5ac29c1"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97704b41cc96f1e339f719ee024385bb83d637bee5574eafb424807f18de2e01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da6990ad3d3b0b4993e38f08e0ddbe201768effabf0727803e2d78788356fd0b"
    sha256 cellar: :any_skip_relocation, monterey:       "977a9592a586b96866dd57c060ecb701dd958441a9390f64d125d2e84b1054b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e80437b05f60d6da69defa29dc4703a5f6160392215a802891e99cab24130b7"
    sha256 cellar: :any_skip_relocation, catalina:       "142062e5d6291359e69e4a5cdaf0eb78b0cebf27d85166c088ff8f805cf4ba2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1192de2588c743260fd79c518db7aec9b822ccf7d44938f81ec26c63b3e281bc"
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
