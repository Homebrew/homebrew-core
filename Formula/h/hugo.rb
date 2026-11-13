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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "177a467f6b2dc87cede65f4df66d391f5b4a50cc8279ccf65566d98e71544a71"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "837660dfd994c09fb36cd94e506faf104b90ce0d8f8e13ba45ff4b167ef4ecb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f661934f403796464f9ceca5883c4f9143ce365eebfa77d593c8abe6bfd9329a"
    sha256 cellar: :any,                 arm64_linux:       "ffc4820f7f6ea573469fe562d7e59cf48ceb268e7fd6decb1e18044eb5a476c4"
    sha256 cellar: :any,                 x86_64_linux:      "44df4ac5eb0ad10659a621bc5c3e8718c0fb4c6efef569c3f409de282c73fb24"
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
