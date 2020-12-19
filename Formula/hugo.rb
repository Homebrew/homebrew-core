class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.79.1.tar.gz"
  sha256 "2d4d387251e9970c514577f92b55a100ff3f0fe7e177e5cc4e7661a8b996b9da"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c9400c8e814ef48203a3018792febd67d195c0bb2780f72f14b971908730efc" => :big_sur
    sha256 "548fa07dec9697e5a4b782bb430881bcb07d88665a31d3208a4c543c9b3d9779" => :catalina
    sha256 "02ab626815e84a1a51fa21d00b0167cdfc9cc859880bb60275cd6116944c95a4" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-tags", "extended"

    # Build bash completion
    system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
    bash_completion.install "hugo.sh"

    # Build man pages; target dir man/ is hardcoded :(
    (Pathname.pwd/"man").mkpath
    system bin/"hugo", "gen", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
