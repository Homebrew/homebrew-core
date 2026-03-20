class Dry < Formula
  desc "Terminal application to manage Docker and Docker Swarm"
  homepage "https://moncho.github.io/dry/"
  url "https://github.com/moncho/dry/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "0fe1a152f318f63e99816b444e8317e3d35749e84ee050530651fa62b863efca"
  license "MIT"
  head "https://github.com/moncho/dry.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99e4a794987918b7279f407918d9233aa2da279f7c5358a7e4e296772632e7b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99e4a794987918b7279f407918d9233aa2da279f7c5358a7e4e296772632e7b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99e4a794987918b7279f407918d9233aa2da279f7c5358a7e4e296772632e7b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6b2a335ddd33be8bfb95b4838b609f20ca24fd6f91aab5c7a6ce0cfe2333406"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "154efb5300c2de79d9afc216e32d61f1cdfac5ce25f2706776a3a6876b555918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e92f6e0308d21101d9dc965f9af80fe05575232bea0b4aa06301dfb22eb6f0db"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/moncho/dry/version.VERSION=#{version}
      -X github.com/moncho/dry/version.GITCOMMIT=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dry --version")
    assert_match "A tool to interact with a Docker Daemon from the terminal", shell_output("#{bin}/dry --description")
  end
end
