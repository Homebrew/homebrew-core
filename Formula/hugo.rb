class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.24.1.tar.gz"
  sha256 "c7a5d56b528dde7c8a12044f7ede1f9d8c1c8401969ebef9a11695d00f8d3d55"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af1846b804d985fa755be8fe7b59ce4d4e5a2aad8c0125434e6ee301fa4581d3" => :sierra
    sha256 "950d27b5d0d15394dd77155a04becb6bcdf756ba172c613652d8f70401bebaa4" => :el_capitan
    sha256 "4734553a82ef1fc9aecd8866e4f311e90f897e9f986b1dcf5a8770e430f4e2db" => :yosemite
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children
    cd "src/github.com/gohugoio/hugo" do
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
