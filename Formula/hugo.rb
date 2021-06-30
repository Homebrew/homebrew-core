class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.84.3.tar.gz"
  sha256 "e9529dc3fbbc905c0c5364cafd97ff14ad2df18caf0ad36a7007d4784088070e"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ebcf2612cb2c49917931cf636f42eadeae6b3d0bf62e9d4000d4dafe822f1ac2"
    sha256 cellar: :any_skip_relocation, big_sur:       "0086d1869019b81d643fb437042056759585cd98a19597406015ce4f53bde3bc"
    sha256 cellar: :any_skip_relocation, catalina:      "45b19e6085ba0caea1b32448d2e6f70504d09d688f21d4fbdfd32e1a4ed60a71"
    sha256 cellar: :any_skip_relocation, mojave:        "ff3d3c240a17a820fefe2a601b71bfd0d9ba041eb0620018bc83a3dfedd6a994"
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
