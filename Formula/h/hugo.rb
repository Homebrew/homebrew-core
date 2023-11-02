class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.120.3",
      revision: "a4892a07b41b7b3f1f143140ee4ec0a9a5cf3970"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c75e64116b4a799c4f54e9534424c4f625315f2e11e944b778cab9f6a86def7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a78e56d9b09cf37f773cf028a5c85446c38d45c1ee6f19a840e684255cc050f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da40b4b44749b1fc32c73f2afccdbbb3aaaecdcaa4af4716777d257e774b249f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7312d3325740f51a9c778cf06ffda236f4cdb16a1d7420d5114e279e8b3c43e2"
    sha256 cellar: :any_skip_relocation, ventura:        "92ba3204c15f18809cb5cbb4625bd2f29250d987e4ef70fe5ecb3a7348a52211"
    sha256 cellar: :any_skip_relocation, monterey:       "89131c6779a4bab99ac291324a0351554402694ecf1b4fe2f652c05a8e957f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b52cd28e784c84f495ef87e8653f9ae105e9011ff128f6ad0b873422b9498cd"
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
