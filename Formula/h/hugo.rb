class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.118.2",
      revision: "da7983ac4b94d97d776d7c2405040de97e95c03d"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0544bddcaa7b0cb693b557f2cea279e884fa36b816cb5fa21fac18d83de4a820"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "653243f98c0ee80ba706ac482a1a0486922260fce6998cc9239be88fbf81fdc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03725c0752bf4483358ed60533f44f4b76d01e66543fc2065d6df8a25caa2017"
    sha256 cellar: :any_skip_relocation, ventura:        "3a01a62b12089b23abff51f239cb384d67498aeaaf31df88884a0ab72ac127e0"
    sha256 cellar: :any_skip_relocation, monterey:       "b6dedf1096b4bcb8401b40ec3a9d753624086b42e75a41dd32361b62f1e30bcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "be04de91302d404cfebdd233fde40b30e021ddee09b5cbba1595e7206155dd0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbcc8c005de68ab1278963414826690d2702550355a58966937276e0f9a16087"
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
