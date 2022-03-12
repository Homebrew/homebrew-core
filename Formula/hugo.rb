class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.94.2.tar.gz"
  sha256 "315bc0d22977e84ba25125b1d23333648e36194a46a4d6ae4f4c6c683dc8979c"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16ecd9a5b5656aa5a6e20e32a4543d7122bd0faef5eaf2c2357838c46807cbe0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39b80e89351087cf05d80904bb575f2e1057769f350b88fab2f13421aa675aed"
    sha256 cellar: :any_skip_relocation, monterey:       "78dd0e274b22be1abb67a0ae4d2ed05e59b91e80eef438c5dbe4d6f093b08b34"
    sha256 cellar: :any_skip_relocation, big_sur:        "b24027a098b0bbac5f2c65599d9a42c575237c95f4a8189627ed47914e9eacc6"
    sha256 cellar: :any_skip_relocation, catalina:       "0afb3af78cd10af2b775611a4088eae2af83a558eafc4f604c92a14abd471465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25d9e2f567c3ff984b0fd8568b781180d938fb13f620027b3dc8df221c6877cc"
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
