class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.84.0.tar.gz"
  sha256 "4d5bf4888c3a652bec85b6a1dc05a55d9e26f9e315fc7e98bd720c0a36a405b8"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7407043f3ac8c574f97fe87b539701f39c270faf1f2c81263e0aab62d333b422"
    sha256 cellar: :any_skip_relocation, big_sur:       "d2fe202e4214df4b858f0b9f3cd8b69e7c2fc9db72b0709b6a2f1375128e76ca"
    sha256 cellar: :any_skip_relocation, catalina:      "21891fcdfd49e305d2b51a5c2c172c3f10802bb319d77bb28e56fdd77c663b19"
    sha256 cellar: :any_skip_relocation, mojave:        "1360554ab1038eb65f7687c141f0e22e04a0a30001932facc6a756f945db58ee"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-tags", "extended"

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
