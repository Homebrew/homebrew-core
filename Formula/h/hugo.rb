class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.125.5.tar.gz"
  sha256 "5575ec2a1aeefdef335c0be8e5fbc6f14bc51e941267820a6ce725928a89b335"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80055e9ba1517c4984f649ddcdfa4e0b6bef56504f535f0534f2b7e2e6a903d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6686f06be847af1293c76b144d6f7b36ef3456ac6811fe273c130608b7d7244b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc3975421df819460a05cbaf7d8d4fa45ce9c28126b8f693ab6337f441909541"
    sha256 cellar: :any_skip_relocation, sonoma:         "8eb344eb55f47bc42a1e395b090dce1d1becf2aaa20f5fd3ad83caf55ebfe022"
    sha256 cellar: :any_skip_relocation, ventura:        "b9fd11b6e694f49b684a686e8edce9a0bae8b968e2df309f68017864b0adcb5d"
    sha256 cellar: :any_skip_relocation, monterey:       "13ca92a1775c38ce36962301b247eb40e77b2243e70433c5d728e03720e6e521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f867e7b507016e408b1abf0ed2f15a2a10a8f64913ca772cdbae42ad1cc0bf51"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
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
