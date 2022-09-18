class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.103.1.tar.gz"
  sha256 "9065beec7b46be56052c44bc4a2f8a561ae842af643f59915a98842531f62efb"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f223d9f34820a83b691c99e81876703db0696ee285ea8c5e5811a7c505df460d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d272ee4365a69a22f172eadbd9a473575aa85ce027576d9f1085dc88271dbdbc"
    sha256 cellar: :any_skip_relocation, monterey:       "ee4f90c177fb52267a0f7344faacda860cb9a97980ec9c12df5476ca0915f759"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6b62991aa0882dab9733fb7d9a7f967f9912dd4d52e4117126bc8648592d8d8"
    sha256 cellar: :any_skip_relocation, catalina:       "770492a0054921624615d4964a9c93b127af2dee42ac8c1c87a862a394d2e500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6814e164f96fb46c3503c0ac2d5a7f93896138453e3d936b4ec10cd7b56c7e8"
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
