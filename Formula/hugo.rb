class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.94.0.tar.gz"
  sha256 "76f6ee1f9138c7f5562f02679576889d0087910c9a6e49ef16a5ebbefda9e917"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "097d4a6e558c57c2ad3bff51faa752f7824ad91394896270f6edbf65638075c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "657ab3c0aad2eaca8cba151d0746c36a42bf2b9583fd208fb453f20ee21b86e4"
    sha256 cellar: :any_skip_relocation, monterey:       "986790749d5b86cac3698c4ef708408135c3b147407620580f1e285d30b2780f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d4a6c552908a43dab7f5bcf67ef11f523795ccc1a1cc929637abb420caf822f"
    sha256 cellar: :any_skip_relocation, catalina:       "98ecde339067e3e0a3e7b1436662d4b88b3a3758fbf3b4d0cd1fc2e32b8e3eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18998093ede262c3f058a0c1b5e081f452281ef0e8a1dc19755444f3a5765f8c"
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
