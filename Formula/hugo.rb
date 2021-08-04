class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.87.0.tar.gz"
  sha256 "04452df07f7cda063a93c7965f30dc7e50b30a4b1dfc42777cf9579d3b14318f"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a8cf557ead407499c27859e7edba7fdad3f02d666e963cfe99f728a45e9f1559"
    sha256 cellar: :any_skip_relocation, big_sur:       "e0b1c3ddd69334c8fdca66f81ca6d3fdedd615d43bec2ac89adaec226a640cee"
    sha256 cellar: :any_skip_relocation, catalina:      "c9167f1383b6fa3868f08326d58f43764a86ed039f79484d6e65fc9addcea1dc"
    sha256 cellar: :any_skip_relocation, mojave:        "5c57a59a45acc9ae9e68e9fb13552accd760c53c7cb3a2f4e859d0d85eb13a0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f15663fdb72861ba9a4170ccc4a7e29991fa677207922087e73217108c5ebb1d"
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
