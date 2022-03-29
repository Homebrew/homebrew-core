class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.52.1.tar.gz"
  sha256 "c234566ea3fee4b11ca34ed0ad11f907cb4cba45d75f618e86d2fa0d7bb6637f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6d82f8c7fce73d7224915dda3ba87797c067688a7280d81402c3521d324a3c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddf35333a207e3929b19efda4530d22cf7b791016f7196106254d567865f2d75"
    sha256 cellar: :any_skip_relocation, monterey:       "659e00d2017d193187ec93b719a4e8e23aa1fb96907274804850d4457cf0781c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c92bb8c7b99a88b8b0c046b73fbe3cb64234258d6ac0f9411867df45f724dd22"
    sha256 cellar: :any_skip_relocation, catalina:       "d6e3c927e3c026019befd2b820d161eff3cb0badcb5dca7d55cf1396817dbd02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceeea5b08c2eee43dc5362bd8b964493e44d9874e228decd00b7923b93cf64c0"
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
