class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.123.8",
      revision: "5fed9c591b694f314e5939548e11cc3dcb79a79c"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bc80ff59b610e29a2ace40e6f473b3a8e3703c8692374f5fa2abf282081ca61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eac5a8b402883c98ca4db18a6c756b6366034dcfcfcc1e8995afce80ac6e1805"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed8b53b0155e9fa061498a46014a51857abb901091e967846d54e95700b18ce6"
    sha256 cellar: :any_skip_relocation, sonoma:         "19ff754be77f7aaf8fc2c19aca89fc8a94ac4f21b7c4d7355245011bc4e36867"
    sha256 cellar: :any_skip_relocation, ventura:        "c35c119d767d3b78b6c618109b043288dd30e7a5f8c6e6729b0de581aebc0d76"
    sha256 cellar: :any_skip_relocation, monterey:       "28f4db927f240876d088ddd2ddd244781f71347c5880778a58a2042c58814438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf72ec2bba3e5c12fd7959bce7d057edc3f1b45611d38e670d7f191a050a4dd2"
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
