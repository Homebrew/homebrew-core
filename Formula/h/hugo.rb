class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.152.2.tar.gz"
  sha256 "45ffd018ad8a15d91f8689e76a3b2cb8ce73e82b3a7ae2ce632212c36e77665d"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da186c4aee33d7b7dea84afc0891654fc48d293db25b3232d4f41f3c0c437acc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a46f606d36d1fa437e75a1e6307d25ab26d5cc52556f2aeae7c329161c1cc180"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9898b39f03442bf870a71bb35ca0af1de07c5750452547cd586488001bbc7875"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dc3f22217d4ff44e7d59dedfeba99ccb58223e1c2bd8f5ed723ed2f3eec663a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d7e359b0b5bcdecd45de75e5218e8f57571d944f6d40d74ee3e159358aeb8f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03d0765b1d2b4168a7cd14b80ceb9965797d3b41ba805a88e7f5d007695aab98"
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

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end
