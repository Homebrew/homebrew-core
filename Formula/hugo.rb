class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.83.0.tar.gz"
  sha256 "c22bbbf4f3e12bced1b6b73ed1b31f45b9123c3d37ccacf2d899c06aa07550a9"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ccccff9aac4155b16bb9ab3d60f985eba8a6f7d4a41d9ff177116b79e10ed55"
    sha256 cellar: :any_skip_relocation, big_sur:       "b2caf8d044315b1b2c50e801d71cd7cc1264f01c412e0e3fcc3c821c141ca443"
    sha256 cellar: :any_skip_relocation, catalina:      "72457df2d1cbb46d17c2073e6763f5e38beebff4bfc7ef24830259ad5a92f6c9"
    sha256 cellar: :any_skip_relocation, mojave:        "e3e75189738845e6e1975b70dc5024cab2306bda750dfdec757e43373be92f50"
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
