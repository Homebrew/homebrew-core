class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.124.1",
      revision: "db083b05f16c945fec04f745f0ca8640560cf1ec"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74aaaee0f43407ae00c469ec8d7c36e31dfc481cd31926dbaed21a094997536b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b738b572ac9625358fb1ee232990dbe00183daddaffef3756f08bb6bb540ddbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eba8aafd29b643a6e0754046756f8d34a782eac8b321d21d9629373b954ef84"
    sha256 cellar: :any_skip_relocation, sonoma:         "918f6c91206de56f3c8daf83eef198883733c0b974e96dbcd107ae1e70644fd2"
    sha256 cellar: :any_skip_relocation, ventura:        "79b7063a58f7914e83331d4311a16987ed0986852035b55a2c39bf07db2e4580"
    sha256 cellar: :any_skip_relocation, monterey:       "a62aa42718d41147a12aae0fde9d825ec66c6bc8dfd6cf23f152e6c06a766c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6119fd2c8a03f31e2d332f91051d3a7c37660fc1bdccee0c73db0fddc1dfbd4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{Utils.git_head}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
