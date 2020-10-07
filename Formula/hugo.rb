class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.76.2.tar.gz"
  sha256 "03a32d3c7bff0264bf5e2cb995bff6250c9b6a05a7172ffe98c4f923226f7181"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f65ce61ba105a001009fbcdaf2ffdf35641b10e17eb4ae7b81773acbb70ecc4" => :catalina
    sha256 "15402ae6a4b1d17f513218241a99de55c75ccb5b3967a0210e60df601efef89f" => :mojave
    sha256 "5ab4995c05964bf97d1bed1638baa268295519d3773c10bdfe1b3215ea430c8c" => :high_sierra
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
