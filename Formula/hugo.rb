class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.57.0.tar.gz"
  sha256 "fe71e3dd5476cf3eb653ed9947d52a2001e20835f7b118fc6b0bf206c7f7a5fc"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7a9814d70659ececb1eca730136f3f441a0d28fe4ec614aa8dadf8b4a47290b" => :mojave
    sha256 "7535fd8d083a84dcbb5de2b779067dfbc45ae76c9cee0dce72988b3d72ebd03a" => :high_sierra
    sha256 "8a37847239ecdbb4d06f959d6759704be239ee820ba79e78f40bebae6691f51a" => :sierra
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
