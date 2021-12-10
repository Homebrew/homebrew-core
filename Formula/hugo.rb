class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.90.1.tar.gz"
  sha256 "456789091bfe30dd3f69b63ac627d6e08ae973326294cc6517be8ed70353af35"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9fbc9bfb18b2b6a4d259c1ac108ca386343a7e2e0f91a76e399cb5b20e7ef83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad67fe23a7c3893e30f6adb82f44c2f35962fa18f68daf461b0cecb2b206819e"
    sha256 cellar: :any_skip_relocation, monterey:       "3c2ae11ea5e25a5954b8fd24729c8234fc98f1fbddbe24fafeb1583fb704133e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b36a9121c2ed52234be85a776d72c23e8bcd2004bcb5abbe1d4e1b9cc0958d7c"
    sha256 cellar: :any_skip_relocation, catalina:       "8943423fc4113b64e6e73224705375438f149c350ed178295e26bd7872fac22c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66b588d7a0b4ef59203e2ee5208590c20c0cae6d3471f90c629c192ac0729fff"
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
