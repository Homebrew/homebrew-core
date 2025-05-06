class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.147.2.tar.gz"
  sha256 "c7e042fc9c4c3f3b7bfbc672540b01d5abe42499f600f16e31e7d61065213dc6"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2372f84528995381e088869770535fb0d7b213bc9c6c6cc757ebba9f7f247179"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a94117a30023c6b19aeea043f691daa30a02a83ade753c17d8abead8ca2f6ad2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b927ec1f3ec55121ae76038b76aa19f4c6ed3b067a9978598f77cc48e8d5f1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2925d2381fa9b5a22797345003363e384a63f77cbce8f1eb8e34ab523fd4f5d"
    sha256 cellar: :any_skip_relocation, ventura:       "95c975e6b6740b10e72d3f55c83721f112d0678164a0f4b7abf91870a2577af2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50673376e63f27e2a933725e2f9c2a4b58a5a0db44212715e901cc5e9e96bfc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ee277b556cbcbd5f0153672da7f569c57e2f21884b7e6049a9779eb27a94885"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
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

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
