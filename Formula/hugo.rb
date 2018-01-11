class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.32.4.tar.gz"
  sha256 "044c6214d53aaefb86deeca7305bef189efc9c624485d9b737e1a566ab34d02b"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3efa41fb7831e4d302580c7da7d5c1aedd234c029f9ce0564775d03ecf3a6a9e" => :high_sierra
    sha256 "3e6f8b78e1cc7bd5f2413fcdff3bde1f837f1d410b34fe5d0302252d416a4753" => :sierra
    sha256 "7bc6cae7f759ef675d764ffc1d4dd5d31aca3eea561fa511779154b00df63363" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children
    cd "src/github.com/gohugoio/hugo" do
      system "dep", "ensure"
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
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
