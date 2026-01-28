class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.155.0.tar.gz"
  sha256 "fb38f6b8f5b551d4ed116dd6fb13ec461e45cb65b9528ffa02b467ca578348d5"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ffd61cb3b8bf99e34dcb844e7f9ceca9dfacccb560ad7854e94d373f2e79e38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b4cff40e42eb847854909bcc72f9db6b8c0b42499bde55c043a068b157b5f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "664f118272c87b12d58c41672f102011ea105a303a6e2c5b9d29ba9912b0c254"
    sha256 cellar: :any_skip_relocation, sonoma:        "b32b2d77438b9be0f6a886ff43cb5a766ad43215278f830fa3f450506bb12103"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b97223739f3c3917dc9112fed3cdd5654316acb621d394bfb7b0a44bcdf8fe3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28d3cd5e699d2326b1d4bcc5aef81375ecb1fcdb4149d62cb01386017ced9e31"
  end

  depends_on "go" => :build

  def install
    # Needs CGO (which is disabled by default on Linux Arm)
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=#{tap.user}
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"hugo", shell_parameter_format: :cobra)
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end
