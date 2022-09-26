class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.104.1.tar.gz"
  sha256 "165cac60e559d9db8cce61b95081fc9c5fccaf84228b1a33c325a0963af2be48"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9891450a39bbc96221ba3cc75f43ecdd62322332a9819112b01571cc9c7b07f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51bdafdfc8e949fab779e1875612ddd8d3e8a064edcc7bb1b325f649db30c236"
    sha256 cellar: :any_skip_relocation, monterey:       "4d4ccd351ce8560654e45b103ce2ff77d81fc5434bb941e72c8ed4df5d460d59"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b3a9825bd10472f46457ada3190d89169efb8e02e68f6bbfb6285c7b3621c00"
    sha256 cellar: :any_skip_relocation, catalina:       "68d690f53a9b602ad5723c95b5f96ee4bae1b73753c0c15666c16ad663c7f6ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a4ef5ae3aa5e9874fca59384816ae9a03867c8b3a845bc36fba975a35763b42"
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
