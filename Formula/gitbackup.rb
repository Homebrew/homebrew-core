class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://github.com/amitsaha/gitbackup/archive/v0.8.4.tar.gz"
  sha256 "1d110658874dcb96d9de7cdbb7a54bdaa6e01a77a2952bf881a20d58235d1e7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee940778c4de907a7c62a212d36bdcf18f603d4ef8a13107eb4ee8ed544fa2d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d252dfcf227ed7bbef92ce38e7583c30eb6076b4aea1fbda4a3787e534c08d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d252dfcf227ed7bbef92ce38e7583c30eb6076b4aea1fbda4a3787e534c08d2"
    sha256 cellar: :any_skip_relocation, ventura:        "00bd5db22cf631c65a3e94117956cf634d8a3884af6f157147ff76ad351b00a5"
    sha256 cellar: :any_skip_relocation, monterey:       "fd373f206b493ec79fbcb94cca3f36e2de7881e4aef9fcb4422cf94334ba6057"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd373f206b493ec79fbcb94cca3f36e2de7881e4aef9fcb4422cf94334ba6057"
    sha256 cellar: :any_skip_relocation, catalina:       "fd373f206b493ec79fbcb94cca3f36e2de7881e4aef9fcb4422cf94334ba6057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1597e86a57a79f25d0acea80e94255a10df45c6494767853025cf87755ba76fe"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Please specify the git service type", shell_output("#{bin}/gitbackup 2>&1", 1)
  end
end
