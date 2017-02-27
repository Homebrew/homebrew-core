class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/spf13/hugo/archive/v0.19.tar.gz"
  sha256 "f2d1926b226b4a5d64c4880538eb1bb47c84dd886152660d72c69269f7c5cf6f"
  head "https://github.com/spf13/hugo.git"

  bottle do
    sha256 "867119475450105e8cbc7b7d7f5f0457de2361ae13f9b13cbef4f570652790d9" => :sierra
    sha256 "7ee882458f979268c8175d52bd9c8fa8f3d3439e31e265f09de23f35b0ed6500" => :el_capitan
    sha256 "d5dcfea463c4dfe7010e3acfacbafb42f190f33b7f4265e5fc78b71c93a8d96c" => :yosemite
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
