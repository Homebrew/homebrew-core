class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.86.1.tar.gz"
  sha256 "9e4b65249c890945b542d1e2737bdc3cb2240cc9ad081670ae5a65543002f90a"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3c3a43fdded2882f3bc56e3fc6598cbc15891a0330d128874d879c3ef94c632e"
    sha256 cellar: :any_skip_relocation, big_sur:       "69b911ab8782640f91b318ef907f853c53ad443a847a3147395d833a33f8c5f3"
    sha256 cellar: :any_skip_relocation, catalina:      "f7d5eb1b2629d72e4377ef85a95efdd80b72010100cd7efada5e164b35e60813"
    sha256 cellar: :any_skip_relocation, mojave:        "5eb99a9876d32c7a47d3b944d2cba5b756288122498ca1ce903997856fb7822d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90152f6de4e39094da6e0d983251ee6224813b17ffca49e3db7834b42731a38a"
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
