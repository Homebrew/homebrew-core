class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.170.1.tar.gz"
  sha256 "bfbac02de9f08914545490ef17501cb0d89e63cc95e05e51d5bd9907da20505b"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "d7920446cf3e38ff42e5795b2add81866fa159d63733e87a4bf513425249d8e9"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8322c83fe03457f067cc2bfab88e348ff76f4e89a1691ae849dc1fa0674f20fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8322c83fe03457f067cc2bfab88e348ff76f4e89a1691ae849dc1fa0674f20fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8322c83fe03457f067cc2bfab88e348ff76f4e89a1691ae849dc1fa0674f20fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "12ecee91e1e22d1ddb1b103182421887c24fbc82b172ec5178ad8a25b9588683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8c5a49dbdb5366885d21e28cf43e14f8be96c3666e897fdcc0800ce6c2c9a846"
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
