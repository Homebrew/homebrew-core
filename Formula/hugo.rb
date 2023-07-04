class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.115.1.tar.gz"
  sha256 "d966ef63cde53412bf36c57fb3f04beb106e3e575508a3c32aa793a2fb0474a8"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73828f46cd19ae86999ac7da56254c7850dfdffa9f63a459cb91cda3961aa1db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1be6686826d2f845c083b456e3bc20000004dae91cf1c5684daccb03d129797c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cf649164a7c71a3876e253a667c0a60f8481a66797f51f9eaef106cf0a9dcc1"
    sha256 cellar: :any_skip_relocation, ventura:        "0c697f6f5db797082169361127767526960622ff4a34f3e6decd6df514f545df"
    sha256 cellar: :any_skip_relocation, monterey:       "8d8e3f298641deda4ddc5cc3179db2b4aab20922f7a2f099bcbcda295f09fa35"
    sha256 cellar: :any_skip_relocation, big_sur:        "664b9953c8cd98f3c90d0e2047d683686add2e616c158d1f23a4a06ff1b76ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aadead8264fed95def4a09e1b1538cc4b7c61c8c64fcbf4116fbab64126e1357"
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
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
