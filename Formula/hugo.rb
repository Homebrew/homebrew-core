class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.100.0.tar.gz"
  sha256 "790c4f218e6380f31a0d5c10bacc7e1f7b1533ccba88ef526f764d413325cff1"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c2e5a803aefd6eb0956025dd5a6b210e45318d2143ad9ee7bc6489fd7db0504"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12a6e0762e75fd3d7f58a530d5f63e76088841a7f267cd048a34076b3bf8edd3"
    sha256 cellar: :any_skip_relocation, monterey:       "4aa9037fe49085833d223c2a5635cea83fe284d9f746abebb61df97957077adf"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6e488ffff77383563183a2559d5107cd2f536ecbedd4f2e88dfa269254934e4"
    sha256 cellar: :any_skip_relocation, catalina:       "c3d92f80b04d49e73ff96bc406a00d073527f569f37c0829c53210821bed548f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2433149ffc2fc14852b53572224d6fa2e4686b9c4b8f2b30bc98b92fdfc85343"
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
