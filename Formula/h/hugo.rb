class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.125.0",
      revision: "a32400b5f4e704daf7de19f44584baf77a4501ab"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "228c791c942feb096c74d64ee016c10020edbb082e7c88db551dfcb7ecb96cf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ce43228cf24ba7fd190978b6011b4a9b130bca12987ebb1130515c1d23bb704"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1179ab22d86020c55558c07ad55412025c3ab364b0164a107b36560b8f08a37f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad0db3be57aa88ab1f8c73d040fcb2e840aa60dbf823b06b896474f6a1bffc56"
    sha256 cellar: :any_skip_relocation, ventura:        "52ea67626f4da0424e52c5c546d870a2a3555670cd0a482836186007111b056d"
    sha256 cellar: :any_skip_relocation, monterey:       "37a50ec8b9a8a4e360dcd6d24e6d663ee477fa69e75754b43019cb150bc63078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8339ea6dde66b4b39f8267b4431d13670e2afea4edb0da4f59e55088db44d09b"
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
