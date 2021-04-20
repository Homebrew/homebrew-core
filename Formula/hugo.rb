class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.82.1.tar.gz"
  sha256 "3190ae848fdb1a04339c233faab5934c422d85cf85ea3b0c0b5a842239c84e75"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8b3a5986c01bf0886319fa7fea264aa79e913cf520dda2bff3deba9822951efe"
    sha256 cellar: :any_skip_relocation, big_sur:       "aea7598c4ed503f8034e5217d990c647abf4c53029dfe1338ce2a5d822b1ca8f"
    sha256 cellar: :any_skip_relocation, catalina:      "fbdb0e8406d3f20a544d53d75253c38dbb716647209e037fe76afd21cc3a7223"
    sha256 cellar: :any_skip_relocation, mojave:        "e8b486a03071048ca044908ac526e728e8d1382795d1e02097305b41aaa0bda7"
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
