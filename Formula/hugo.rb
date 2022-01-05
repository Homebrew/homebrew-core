class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.91.2.tar.gz"
  sha256 "a749485225d682dee43ea6a0644d5bd2e587c0535508be90e679b21e4553f8e9"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "707bc39e3622902836f81c666f5a814268456ae1689ef0995e9a78f0fd51a343"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00099833965b365b0bcad89fb1ae068b87e61320518fdb03b04271109634bdab"
    sha256 cellar: :any_skip_relocation, monterey:       "81780008f9fdb8f9a4dc32535f6c3432ac0eb1aa69336652a58c9927ba22b340"
    sha256 cellar: :any_skip_relocation, big_sur:        "89b3f44c96f241a7d66ebbec21c7b1ebbe2a84bf85f6a8ec643564b3e27e0db1"
    sha256 cellar: :any_skip_relocation, catalina:       "92eee80719f2cfa76a649e242056eb9b55cfc33648bd54958308af604901d574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fce94a4d9e3e03c50c0beb589263d8ea3311a487f2ec0798021071048898a14b"
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
