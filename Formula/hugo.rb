class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/spf13/hugo/archive/v0.20.3.tar.gz"
  sha256 "607817b70943090e8dc0e0b916d6f77306bf30fac609e10ff56311e17d49f809"
  head "https://github.com/spf13/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee0854f2da77546ee824967b340fcb4bc8739671a5e4df5913e84b3e9af6ebd6" => :sierra
    sha256 "d66478980e69f48cea8bc7dd99394ebe76e942c8705d4cc8bcfaaf50f9fc2df0" => :el_capitan
    sha256 "c27eafdf6c2c4e7bd0aa3ecc1243c31ca3335a0ce0c6801364c1e6cb60a059fa" => :yosemite
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
