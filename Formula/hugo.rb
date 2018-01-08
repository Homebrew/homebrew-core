class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.32.3.tar.gz"
  sha256 "2ff69b12cf1a8ca6c76d90d29fca63b6ce5e21e0d73e46366b98a2245c9095aa"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd68cb3b9d3b8564360bf3821fabb4dca50fd4d028f75248dc48de141bfd29d5" => :high_sierra
    sha256 "0ac4a408e11fa2cec7534d856a0f98f4f8f34be05aec2199d18daa45c2727c10" => :sierra
    sha256 "5cf700e5d73f08519bb84abca3d0e6014acdda17bc8458c79a217a643dfc1d58" => :el_capitan
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
