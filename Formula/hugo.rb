class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.82.0.tar.gz"
  sha256 "f156c31034f013b11ff19aec09ab4d47fd8689befaa6f58222b48ed970722b4b"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2f469a5252a1d07b580279c48202edc16f50af6acfe9411ea8433c6260051f90"
    sha256 cellar: :any_skip_relocation, big_sur:       "d840be0904e6c525d37132d2949d475b921dca3878aad8ca34ea85be33eaba8f"
    sha256 cellar: :any_skip_relocation, catalina:      "ec6ac7b2fcc151a76ddba5a50c139a39dbc4c9f086f19b6c5a409984c0cc4355"
    sha256 cellar: :any_skip_relocation, mojave:        "eec0f629b184aa49b012164fcf37dd2e7b4b47c578cae9501a5d2cf7aa01519a"
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
