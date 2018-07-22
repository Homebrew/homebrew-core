class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.45.tar.gz"
  sha256 "3c7798efe488fcbf3471f608c9e08e5087cf686b6c8237a625e659e0386010e1"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77799d67a06bb8bfd53b08dbe1b9399a3b9d36377c330e129e5166bc5c55c180" => :high_sierra
    sha256 "7477e5731e8dd2a395d0d32b71dd8d99fd850f11fc7c6403bd35cef40735cf0d" => :sierra
    sha256 "22b697368a1fed1cb6109415ee057c5a4a758c70f9301319a118b9794ca22d37" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children
    cd "src/github.com/gohugoio/hugo" do
      system "dep", "ensure", "-vendor-only"
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
