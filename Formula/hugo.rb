class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.83.1.tar.gz"
  sha256 "2abc273ffb79576c9347c80d443154db26be9ae15b6ae66f9b75056c3a285157"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f5997a1858e300787cd6e2e01ff8f87f0d3233f42af4becc040448ce06524d53"
    sha256 cellar: :any_skip_relocation, big_sur:       "32ad322954e9c2962849495c88c88e461d21a0a7d3bfa3aa4892ee34f569bf81"
    sha256 cellar: :any_skip_relocation, catalina:      "99078c665152420113fac08aaea7bdf2f8fe230696b724448bb9f2244cfdec55"
    sha256 cellar: :any_skip_relocation, mojave:        "a45ae895351a549639b40bdbb2a630e8a11ffb68d78a0aa7577faedce4c011d4"
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
