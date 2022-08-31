class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.102.2.tar.gz"
  sha256 "55c2f1bbddaa1a7be6d95ab983e4a671e6d5f7ecbc1bde8a425295845f0dd764"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09d82b2eb833634fb80c8d286e01d14869ea249ef5aa893983603aa814a68b92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4845ac9bd3227e6c5496fc4f3ee70622beac8844e6084a29dd097d7a73608474"
    sha256 cellar: :any_skip_relocation, monterey:       "160361977eed6a31567d85f5a1e6f118711b503904875d790459066230fb7b1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e1d42497883a26ccfbc3b7011f0746cd9b34b51407d0b13f6a854be9b3cabf7"
    sha256 cellar: :any_skip_relocation, catalina:       "fa368382039f30aa5c0269b3ae49c942fbfcc1d47bb28ac4b1010dc8fa1d0766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "788b1f4b6eef1bf5c43da9aa49140965a5e76415e3bd9926d72fde253b994d44"
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
