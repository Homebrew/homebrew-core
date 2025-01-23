class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.142.0.tar.gz"
  sha256 "2c7860bc2452540fe3dea0e3638001be996a7640159a175d0ac1efb9ce23e1b3"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37660dc1ee5257e71c343c3baa1301eb2e0627321d7b541c10d8db45d8dca12a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daf670ad7856e589c0a05e922c2f4c22f154fba006c92e378d7046ee731b987e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e836ea71828a6a61814efcf529228fef8a7e4c02fb2ad94a4361a3bcd327c2e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f4c4fce5d8afa13a79da3f7e9815011a9ccbd185530751a7a82aeb1a11f7db2"
    sha256 cellar: :any_skip_relocation, ventura:       "c3bbe83ea218cbc38e4f1d9437c3a29b043005875fcc82ebf84f067031760dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5563948c8c23a1cb8e57a5dfc5305e8af114230f9c254cfc1b25edbf2b346a0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended,withdeploy"

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
