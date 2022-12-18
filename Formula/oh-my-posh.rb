class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.26.8.tar.gz"
  sha256 "b8b0cacd97c9a57485ae553c5c47ccd452a884b0b3b670ee5c8bd4adc991ebfc"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f11e9e24825f1b91e336580b81bf720b23e96592a9f91ece3c69e00df97fa88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb3e172b829862da6326da4bf690398049c3c04cbc72cd5a29fe862867fbb5b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eab42bb66280fc9a832f270425d20e2d575bac8d67924e048606098fdce6eddf"
    sha256 cellar: :any_skip_relocation, ventura:        "dbbd8acf83a4c2f8707269529ac0b4c85f8945b7898ada523d8f729f7f51cdb4"
    sha256 cellar: :any_skip_relocation, monterey:       "8b9ef58e494fec13d6b23d79abc21e715cf8de3a8c9cc9a2e0129ef432f3a80c"
    sha256 cellar: :any_skip_relocation, big_sur:        "83d3cf6030ebf7b4a66f5db5592345100326b7b527a94b8bb6c1361d9a7f4ef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "103d612946b63fb2d2d6398f5820dd37eaaf061166034f10fcdb6e78507329c3"
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
