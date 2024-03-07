class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.123.8",
      revision: "5fed9c591b694f314e5939548e11cc3dcb79a79c"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e71819f89c438dbde775bbb063089c606d583d49a8321ba6131e74336b720aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59b2e9962894b0452b9668390958d3111258c610a8ebe35fc450a9f95a29c1be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f149089d708cbb0ca70a247bcbd10f56d95fab56b30ba3d08e5652dec136aee"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d99efd70faeb297b3681812d5afcad6bb0dfb03ab8b377507ea10f6771ac6fc"
    sha256 cellar: :any_skip_relocation, ventura:        "e83420dcf6962e57a8ea56ecd6189ea5500aafe48b5eafeed91f7242f36be352"
    sha256 cellar: :any_skip_relocation, monterey:       "83eaf426ac45772436d6834ef36cf9b3a8ee7bcd6119f331d66d64e8dd6cb2b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb75ea59ee3eb7ac61f7806c0ac222d8540b9f686c304df35173fd0d12fc9a31"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{Utils.git_head}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "extended"

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
