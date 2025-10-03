class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.151.0.tar.gz"
  sha256 "b41d6e3da741c8d5637e016a1fa98f36e47dbfa9e213ff2d73ced66fb5b770ea"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e42aee24dff853810a3e863e9a1cfef28d01cc0573215e404045c77ce21f003d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7075bab8a29f3c9ed332e74acaaa18dc07a3d49b4ad88aceeda966df6001814"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cb55eb93ea5efcd1d3cbdba012d2550fbfe8a19b8b967b370494f11a416f80e"
    sha256 cellar: :any_skip_relocation, sonoma:        "68566e8cb2b5dc775a70732a4b6d9c8a88c41d06781c9ad3c4b20c4c2384bb1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f1cfa769f01223e5d46d5470d898ddd7df0c5a607e8bd2bbf6fe80d0849cea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4f42340e486b765627f00ad104735cce763b424f98daf2eeec640955983bd5a"
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
