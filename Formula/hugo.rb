class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.36.1.tar.gz"
  sha256 "3ef3d572e78d0fa5bf41fcbc8d686d168e9ba0548d87d406c55f8a4728131b36"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c096f5c013e79641fc4f88a3f4066ddbfc496ea14bf550eff37d9f6a0fa01cb7" => :high_sierra
    sha256 "d6ff9a33e1cfc0adb47f8bfe8370fb07a0f06b52257002b41f5b558cec36d4c0" => :sierra
    sha256 "a97b410550dea2ab9a899324acd85c6b3a16229d01f9d18caa8b7d8923b337e9" => :el_capitan
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
