class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.91.0.tar.gz"
  sha256 "d1401c58fe0aa78cecca4d28e6b204151e8960b0c0d95a2c48f3ddd4a073da9e"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ba6be571a452fef64367ffa18cf0557e85bf04f4b89b35330bcb083eb25ac32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13eb5ddb36d62f4188dbd6c104b3353167eeac55e032876081ee9118e752f25a"
    sha256 cellar: :any_skip_relocation, monterey:       "013913770cbf83a113385c8ac00a77c77a81af5e69f3f5ca71bfc6622125168e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7970cad03525a909715424d55bb00a33a4805f9431a24a18c202951306a28fb0"
    sha256 cellar: :any_skip_relocation, catalina:       "acdd46fa7359d04bf2fada9117d42311968c91f02f807f96a127cc594666289e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d78c0f8bc176a9745b3743887d851704366274741216d07696ec042fedd8c0de"
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
