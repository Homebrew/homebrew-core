class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.55.2.tar.gz"
  sha256 "d423b3e14c48bc0217fcbae533d49c9f4c6581c30429c0e7505f34a55df53bf9"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63dee9301a94d4bda6ee2766c8b2b987ae9fc295534ed6c4df5d27a0e19704a1" => :mojave
    sha256 "319d444cea717abd61f45e060c1baae703bdaba00e00bcc16a0d55f3bed3b4d8" => :high_sierra
    sha256 "0004ac38ba35a1ad1d1630d397b9535b193b051305dff24e7c6b65954790b1de" => :sierra
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
