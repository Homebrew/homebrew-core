class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.90.0.tar.gz"
  sha256 "f7b83a5aa20241a32543427ca870e3e546cfdd31a97e7c63d1114c62b51d7b22"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcdaa12243e5622003f7d76f1203e140d3c7592f8109bcddcc754a74aee04494"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bd084315fa0a9d6a681f05aff613059bfdfa44976ba0ba279e7e1bfa15ed1f5"
    sha256 cellar: :any_skip_relocation, monterey:       "10679eafb53c401ba867e72e8452c7d7c59cff1090ae79961da3677cafa58da1"
    sha256 cellar: :any_skip_relocation, big_sur:        "48c4030c91c38a2193c4bcd29844c80cc8171680cc8a0f4f09172fe6c0e3fd72"
    sha256 cellar: :any_skip_relocation, catalina:       "42035e1ace83b1e33981ac78a838de2084a045e23aa0428046d73c5613ea2b34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61ae0659db33b966aace9d38f5bafb8ab1b3aed81a9b8380fa97cdd46389268a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

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
