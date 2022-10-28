class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.105.0.tar.gz"
  sha256 "3e0ced73b0acc1c8ae13fe118c7f4ba292a43f73e60a5b1d2f8301c574dc1596"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c8bcce8c9d488522caf90109058b96b3a110655746c3fe995b16daa41a87d1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "945bbfeb9fe158e3420f6d292923fdf147f6ae2f10ee81796ab2abb92bdfe28e"
    sha256 cellar: :any_skip_relocation, monterey:       "cfb6bc96ae3b00f19d3d049237240732e242afd37bb070488917db28b90baef1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d572d2c195027440fe43370216729b30974c975ecf8f5d50511aaf13955b768"
    sha256 cellar: :any_skip_relocation, catalina:       "ee275bfd9155dc8c06a67af7da3a523142fd2e15a5bb5cb4b2f2c7d6e5ea0cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f711116a40f3e9c4fa027f1ebef5805f05b47b03cf5ec14e1eccec16cfc276b1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")

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
