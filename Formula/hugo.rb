class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.99.1.tar.gz"
  sha256 "487e5e3fe63176f554344822c30375c9d948fcc7c669424f7557e9089f695c3d"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dc273e11cfec56ba3980e27c4f5dee35ac62bdd934c33033b6d9a219e680063"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "415f5dbf1963c522854b921f2397ee9a5f1d4bc32cdf35110a04063b0ea53d4f"
    sha256 cellar: :any_skip_relocation, monterey:       "967f159befafb8f45943ddeabbd729f228e72d9ec1c066291950f9e692e382be"
    sha256 cellar: :any_skip_relocation, big_sur:        "886ec66cddbdff606aff41a4b291085cd45b7d07aa6c9e183eae3294f5bbb11f"
    sha256 cellar: :any_skip_relocation, catalina:       "239da3566587abf22a572f39c47c18e43b07d0d798fc4aedf6a6a2eacd43c673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "818bae4236b5a1639f41fb2941a04feeb3fc63c149d59ffa499899673dcc9192"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"hugo", "completion", "bash")
    (bash_completion/"hugo").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"hugo", "completion", "zsh")
    (zsh_completion/"_hugo").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"hugo", "completion", "fish")
    (fish_completion/"hugo.fish").write output

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
