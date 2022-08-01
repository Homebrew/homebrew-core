class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "ada4a61a647983cefe180561d2f20563d8109af5b4b5d8d97ee5f90f481ecd15"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28c91477c53d3611dc0bb22f7f3fe461f4fb445dcb6011d909ee43f31e74373c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "515ce36743d09a2034bab6bed1df3678f9fd70fc3abdbd2f2d77d098e460ca4d"
    sha256 cellar: :any_skip_relocation, monterey:       "73477763fd39fff6c061c333e04c70fe267c8b306bf7f7706c50abd70070d59e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c914aa27cd0c16785b3bf65a5aa6d96f0925fb722d19cf4d56ed49e0159a2f5"
    sha256 cellar: :any_skip_relocation, catalina:       "4d21434bc01b0b7d09e4f46bf1ccf95008510a086d23e66c8a2ca3effe390e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f938e18cf762c6abf6afb4bbde384dfd03a27a0c34397736fb61008fe127a001"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system "#{bin}/dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
