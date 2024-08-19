class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.133.0.tar.gz"
  sha256 "98685a1ac7cceef51f4f23a8fa5a86a32db18c21c3a3f380a5d8a211c420caba"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "492bb83d32f77cbc8d193de6188f02fcc263fbcb1281ad4ebe883691512287fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8cd1827f1fd5e370e41ee570bc3d8762518460a24183303879ebbd0b940c7f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73231ccf003870b4109a2a5126676359b5c45bcb350482dc778904962513ca36"
    sha256 cellar: :any_skip_relocation, sonoma:         "62d7ee282daac70f53c503f3e7ec263db046774c38d08d962eb562d1e0bdb201"
    sha256 cellar: :any_skip_relocation, ventura:        "853afb851e24eead96d842c29cd7f3fe75372bbaea54d0418e7ae74afa0096cf"
    sha256 cellar: :any_skip_relocation, monterey:       "abddf214354f897054a8df65327b2f3a83f9101ad98cdb49819542eaff169580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ef7aa98a76724ecb0250538d530d618892ba8b1d960af12eee776d5dedebd13"
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
