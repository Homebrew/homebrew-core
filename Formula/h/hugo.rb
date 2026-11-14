class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.170.0.tar.gz"
  sha256 "dac429f01212d06979a1e939307f5bffdbfd3f75a63eba0fe3c817383d0525fe"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3d075b229e883e1f2c562b63b3518bc90ede5c115f691f32efdf0ae796847da5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3d075b229e883e1f2c562b63b3518bc90ede5c115f691f32efdf0ae796847da5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3d075b229e883e1f2c562b63b3518bc90ede5c115f691f32efdf0ae796847da5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "46d914df70f366ce7c120959b59d83068fba8e67adbbcc25837c10e45fb4a00b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "844917665574cd3ebcd924eacc015a6be3b395a76cd0e16acc66ff5d8210bc3f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=#{tap.user}
    ]
    tags = %w[withdeploy]
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
