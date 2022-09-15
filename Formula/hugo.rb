class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.103.0.tar.gz"
  sha256 "6c100994bfbbac46e42876eb9387ba81db0a6142606afe16006741e32c096aea"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72f9977b89378f63386bfeeb02be5e0eae59e9a7b57a0e740d22821f7103e5e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c0a870b1059b3f5dee0a37aa24525cbef367c1d686c04491139f81971fc38d0"
    sha256 cellar: :any_skip_relocation, monterey:       "c035e2486a766162da02ae69499d3b053f9118bbbb731df3f1d3c2018c29bf78"
    sha256 cellar: :any_skip_relocation, big_sur:        "70a3c24b474baa55756b6e724d8d8537c209bbff3cc62ceb153b0d5da9e78bd9"
    sha256 cellar: :any_skip_relocation, catalina:       "8e772d6d70a923ba3348e9af794b536f6aad4953e792bc81800e8367a27f7e47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "615291f2b39f86f9f2abd78b81cecc93f3b09e066f0abe53edbbc9c8ba5caa0c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")

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
