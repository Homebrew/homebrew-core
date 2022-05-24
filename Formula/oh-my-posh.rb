class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.90.2.tar.gz"
  sha256 "338375891e760105aaee9c14929d9a1a71a4fd694a43d5f063848d07e856486f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8863acd58af5262d26136353752fee40817ad33f53980b10a883296349c81d55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc04d278094578c99b050449f1396bc36eb2b6982c8eb3543eda104730dc47a7"
    sha256 cellar: :any_skip_relocation, monterey:       "3343744e94eafa8603ff243f1a9ebb982ef4b77e0a2b0a99c012b06ff8a68e84"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b1626a3218453db10997485cf5d6ba362a3da4e247b795c5ffe61f0350f6ec2"
    sha256 cellar: :any_skip_relocation, catalina:       "966cbd14331ade327e65f85e07de38c2dd80fa7f3c4a8c281a9b5eb4cf7f8650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5f5b50f1e671a67a5f1e892408b22dcf60b469b4866dece9f63259d35c79540"
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
