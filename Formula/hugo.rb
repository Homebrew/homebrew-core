class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.85.0.tar.gz"
  sha256 "9f1c983fe649f0d602481c848ebf863c9d3b3bc9c0e6a237c35e96e33a1b5d24"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6a7d887fecf955d0eff91ef0772dbc2a0d35adb66263e8b8bd02df40206c6f6e"
    sha256 cellar: :any_skip_relocation, big_sur:       "89c2f6447bc3f38c26e02b1edc6a1cc2b1ddebd309168cd6ccd93bd3768644d3"
    sha256 cellar: :any_skip_relocation, catalina:      "55c2d8f6c49862c3483b2a971410f566ab74a0ea0d1549d70eb85b888f9bb4b8"
    sha256 cellar: :any_skip_relocation, mojave:        "460d4c128c8b74e8db1bbee669a44b6ab2d115094672247bae70d4eccd64d595"
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
