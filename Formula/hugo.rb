class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.84.4.tar.gz"
  sha256 "d8711de4b34ef602efa4805648efcc5c8b3881138db85b16efc025b5b08fb209"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9b2409e02430b3125f59fc572057123fbd52f2499ea251d6a7917db7cb70b3c6"
    sha256 cellar: :any_skip_relocation, big_sur:       "e61bc37529e3147bee08e103f85c76451e5a9f6b3ca40fa1c5aeaa429ee7576d"
    sha256 cellar: :any_skip_relocation, catalina:      "835a8d57aa0f3407c51129ac3faecd762e58d367cf1970d6764106547db77fb5"
    sha256 cellar: :any_skip_relocation, mojave:        "48b34116a0bdf2073c55322a5397811ce9e37155533ba431ef99b4c906e595cc"
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
