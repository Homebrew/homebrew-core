class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.163.3.tar.gz"
  sha256 "e51d50afd870c601a85c9e9077e18e452d427c5e4f59856b9e83e6565de9c53e"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85fab952c874363d282fc96d3d7cd4f5c4a9b2b178eae0473ad1dec8a67ead62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c43ec4b74d5d44d5a0fd9c6d0e85511ad59e4928134659c3065c803fd93afcc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33812dd832fa05fa563a9dab58bc7ff14692b44942c83835c73d37a729c26a5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "974cf138c9db423572dd91e2d1ba069ad5e137da2c3d373cdc29f4925024be1a"
    sha256 cellar: :any,                 arm64_linux:   "860fbe04fde6279d62e8b33f7a771208aebd8d2c3dfb0ada12e488b1133c7f17"
    sha256 cellar: :any,                 x86_64_linux:  "58c9bcc338faacaf450a4609dbb179647b71e98d8aebce5003eb24a73955c2a0"
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
