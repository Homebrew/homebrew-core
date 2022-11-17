class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.106.0.tar.gz"
  sha256 "9219434beb51466487b9f8518edcbc671027c1998e5a5820d76d517e1dfbd96a"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55440af54c6aa321825da7b166624cd8e56ebd899998ea53bf873a7f14531483"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8973ca4a4610976b39da37fca2d7b879dff4fcd83c22b5d98ff521f26d1f7520"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23786de84758c60d8f629e5712c3bc82ce02b3715de0b44482573bfc4fe7ab0b"
    sha256 cellar: :any_skip_relocation, monterey:       "58c1df5634fe04f2d46638615589b895296d1f5badfd981fb9cb52e314b3b284"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0a8c0b56b86dbc9b892804012c8ea64bfc4a8f4f3927ddcad2588946f4e639d"
    sha256 cellar: :any_skip_relocation, catalina:       "e5b5b50e5372b560cf046c0a8bc0f3d907a8728b320089d4a948d734176544a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8826be098fcb6dda198467096284d88ac6061a5c2fdb9bc6172610731e2c74cc"
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
