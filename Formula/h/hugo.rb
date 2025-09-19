class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.150.0.tar.gz"
  sha256 "ebb96dfbefad2941ec49aaa714e593720b2fcf60d85365b479938a5aa1594cd9"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "936cc3ae9ca2c8ca490a6aadbb717b4233f1f705a40b24067addf925b43c72d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "622c3db4de9af16490b0e38b6f50ba17355c8d1412d5a3f6d3c9a73753305cbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c99d3db375babe92765febce27ce58b849acf780b52447c1d36a0aca2a643f50"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75f2a272fa0946be5149b8ee265d828c4c3379ec71dd75acd10fe470247ced72"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b571f148e38553a541f7edbfc1889403ae967f7a97e5e86637d152cbd32df73"
    sha256 cellar: :any_skip_relocation, ventura:       "5943e1d47f988bc078fb470d9756297c0931f043e473a209ead76cf0f2c9139c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93bd6d035d2b7d4cccf898d805e0637e5c9947a626c5d7d55a70945fce702b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07152339ca632dadc47cf65cc2503276c1e43c348ab6dca587003e7c0cc12929"
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

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end
