class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.97.2.tar.gz"
  sha256 "50aa95adf824257293d99d260c5b42ce9db13085f0bcd9150b2b3c377e7b4885"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "079429ef5ef0e4780c2dd8242f85aa94c47056fed14250beb6811e802668eb8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dde5c94319685832ee89b70a86c83ba764d494a22c454a592d65122493ea667f"
    sha256 cellar: :any_skip_relocation, monterey:       "ce26b268f09c2f9d4809c9f07a7422965a83789b035ef1f442720df126a9dabf"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f598eb1cbb2710dfd89b36d20e9424c1646747c9f905b0871ecee600c743c56"
    sha256 cellar: :any_skip_relocation, catalina:       "14d251a0471cfc8c77479889e75997c4f2d0ce04bdaa674cdda299156f02d1bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d33e46496ec3b20996108f27f59472de59872b1f85f683c156b01d7a5a4980aa"
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
