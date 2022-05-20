class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.87.0.tar.gz"
  sha256 "190b03c79723fd00a47956a0bab765cbdf68f232dbb107ecd678f2a054badcf3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bc385f68d1facedadf52189c3375c8ced2736431e66e8a03a12cd4bf9c9cb34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a346d5fb5cba1de8612a6f96a88d9c7096e7871403ac5e48232c0b9181f86b9c"
    sha256 cellar: :any_skip_relocation, monterey:       "b805c979ef138a4c0a968840c4a9cb12c1c85f2f0566b4e8eef3a7d6332e7f44"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3b20381607e5814f0b7c23b1dbda27b7c9818e655c70f1607ba5efa85731f7c"
    sha256 cellar: :any_skip_relocation, catalina:       "c6d134b91c73f7b6a098fee224a12d7a20c16fb829dd4fa0b9fb4c2db712d172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c446bf62239b67430ef9decf0f7eff1fe511b3a2b1215ae3d365fd460cd10df8"
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
