class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.48.tar.gz"
  sha256 "0fa6bf285fc586fccacbf782017a5c0c9d164f6bf0670b12dd21526b32328cb2"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "632d57305e1d9dc12941b5d49bcc015cc3208b959fc27561b25fa153d9f99e6b" => :mojave
    sha256 "8554ecd55429f03b29572e9edbb822a5fde2fab385ff1736c82d144c1a89e051" => :high_sierra
    sha256 "9f9e0162984ee3bd5ee7487cd327b49d3a3f94048f5249498d8247c2dc86f014" => :sierra
    sha256 "9e84b719eac13b3123a18d2f357cfd9daf86cfcc2cd51248e1dd0de70e86defd" => :el_capitan
  end

  depends_on "go" => :build

  def install
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
