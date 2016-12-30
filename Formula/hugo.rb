class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/spf13/hugo/archive/v0.18.1.tar.gz"
  sha256 "29db2524a3042f507162164ec3ce9071277a7608547f4ea4f739d63cac4b39e4"
  head "https://github.com/spf13/hugo.git"

  bottle do
    sha256 "edbed547dce2b57ba586201b48152b2b3827667f7c23d9d43432ed3db5c016b5" => :sierra
    sha256 "46b10c9d48be1362137acac7d6ba89a17d8ceb928eed8f880c54e9b2b75d97ad" => :el_capitan
    sha256 "887ac6b7450d8595feeb1d7768cfe1ac8f97dc437a8b3bc40ad035aaa912b605" => :yosemite
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/spf13/hugo").install buildpath.children
    cd "src/github.com/spf13/hugo" do
      system "govendor", "sync"
      system "go", "build", "-o", bin/"hugo", "main.go"

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
    assert File.exist?("#{site}/config.toml")
  end
end
