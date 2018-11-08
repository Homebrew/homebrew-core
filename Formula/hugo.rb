class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.51.tar.gz"
  sha256 "5433920c3830df4217c2e6b4e80958543b00c36a890fe4b3c990cfcf5fa46e33"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd0e9db9507a23d368c3ca14c179058ded7e84aebb5b19e26e75639f1d31c2bb" => :mojave
    sha256 "2cacb2d010778d37c28d61390bdf7a10062f6eedd0535f62a937219a70bcd6a2" => :high_sierra
    sha256 "1cbdcd2bb97babc6bb3c7e02a72fa0ab4ee5fd2b9b0435b73c07816f2628e8d4" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children

    cd "src/github.com/gohugoio/hugo" do
      system "go", "build", "-o", bin/"hugo", "-tags", "extended", "main.go"

      # Build bash completion
      system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
      bash_completion.install "hugo.sh"

      # Build man pages; target dir man/ is hardcoded :(
      (Pathname.pwd/"man").mkpath
      system bin/"hugo", "gen", "man"
      man1.install Dir["man/*.1"]

      prefix.install_metafiles
    end
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
