class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.111.3.tar.gz"
  sha256 "b6eeb13d9ed2e5d5c6895bae56480bf0fec24a564ad9d17c90ede14a7b240999"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0da8e425f1c972eaa3640d4a986433f68e44786d64269e2c04c7eb5ad4c64a52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08081951ae2e96f4d896fdc33db305721e726c39b2f3ba2f13a3d72cb31dd678"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a2a4f19657b8c04783f7529d3005dd8e82a577ad4c7165b39242da0d2e57760"
    sha256 cellar: :any_skip_relocation, ventura:        "18961b27d03817073a645ba7849bd8d01dc6fab51be265b13ee146decdb28499"
    sha256 cellar: :any_skip_relocation, monterey:       "5407b21bc5113d5fe8c109b1e15e8fbd28b25779fda14797826c192ab4580210"
    sha256 cellar: :any_skip_relocation, big_sur:        "74df6ca6822c77a3c84c90315dd9bc7fc5dd884f4308b67ba25a1e48ed8106a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e2da89876d6c10e8329735e0c4db8190a5aeae3e93d4df911f674a94ee8c5ed"
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
