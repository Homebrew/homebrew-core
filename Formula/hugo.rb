class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.104.0.tar.gz"
  sha256 "df658ddf913f81364d69b2d6d2e7b792fb4888039ae88fff3c9203470703d6a8"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b580d546bcd90635c34dfa46369a11326ae58e8626ba3d676a70ba72facc1d21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8864b48b2c35fe3ec1b318709b9cf5da3dcf5b2fb13475d23764e4f182ada796"
    sha256 cellar: :any_skip_relocation, monterey:       "77df3563aeaa790a0f5a3e5e1ce07ef75c85d67de8c627744ca246caed27e990"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3538a5ec975408cafa538748a8c8996bcdfbc1f177f88627a7e0d2c5fc63613"
    sha256 cellar: :any_skip_relocation, catalina:       "bdabd53d591aa9af126c4f1e0d65b3339175cd0f4b795349c8c8313b2ee740ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bcbbb19105558be8a20bbd5c646767e4fbda357f26e63eafc53a9c819d81282"
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
