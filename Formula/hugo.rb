class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.89.2.tar.gz"
  sha256 "2fa4814f9e08e3efee3dbc37281309e359cde10e6b99785ee161c0f35c4509a6"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66ed4227e4f33fc3a435fe6b8da31e475f650922b900b77fa550fd5f5f3b2580"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a94748dd61a701f9d461899791d37b4eb0a33e2bb82a793fa007bc971b699de5"
    sha256 cellar: :any_skip_relocation, monterey:       "2f2525cf91f6a235ee92057fbedc98988b6bfc82d64c7b72a0be3432f4c54c8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b90ffb358f56fe941f9d9eb397afa19cb4f8b25856294d1e725a82a15f73923"
    sha256 cellar: :any_skip_relocation, catalina:       "c89dcabe512ee4e55cca91ca1cbcf4050fff6b1ae2a7c17009c47c973c32927a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b315f7c31e393505112fc89e3507d1b71cdc5980079063ed25a16afde6a2b1ae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    # Build bash completion
    system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
    bash_completion.install "hugo.sh"

    # Build man pages; target dir man/ is hardcoded :(
    (Pathname.pwd/"man").mkpath
    system bin/"hugo", "gen", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
