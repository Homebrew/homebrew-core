class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.88.1.tar.gz"
  sha256 "da5f52437bfc7521b194b39d36a8cf7b2775e70e1ba8c443f81a14f468608507"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aeee79c18d882f8936a2e9475866ead2c4c775825f709a472f7b5f93d9e63877"
    sha256 cellar: :any_skip_relocation, big_sur:       "a785a88f4303d151fa1594de113a3ab1fc884365b9dddae3aaab551df2147167"
    sha256 cellar: :any_skip_relocation, catalina:      "74e1caac129620cc72810277546e9af01ee7024adad683181bfe13f8837e051c"
    sha256 cellar: :any_skip_relocation, mojave:        "14de26a54b31b345c9b77a97dba548672b5f4d4f72b6da7943bfb90490213a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcbd7de5d1184383ebb38725d7b71fc310b681a10f33322b044fd0a4518aadd2"
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
