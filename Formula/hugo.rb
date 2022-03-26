class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.96.0.tar.gz"
  sha256 "5dbb132438b4ae3dd8303b34c8b7480674ee77236ac3d36d0edc82a06a0c3219"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fe41619731a0fc4a7ed886dbe7d96bdc3bdc99b7451e2f47931acac8b83d6f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da9cf92eefb63abda9c60842c408e1a09256deb876e015d6b2dd5cf180d6de35"
    sha256 cellar: :any_skip_relocation, monterey:       "722d5ce5c632d42c01087bea9756b3de9bba31cd67f0faafd571de36fd66c6be"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6418fd4df0c75ce01571eb40275a575c186bf043fe0473789270690d0d2c93f"
    sha256 cellar: :any_skip_relocation, catalina:       "9aea80d223d932c6f752ac9660dbc9a2ae366f1545241b5e288ce31bed63be20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7a398fdce8410d04e469d051f2a425a705f14667e75829a2bc001fe85b7a683"
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
