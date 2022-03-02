class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.93.1.tar.gz"
  sha256 "b21d83c1011a785ab28716227849d661671e00ed9c43b195789835d439d0d60e"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "925926dd489892dd7beb102d448138889d3a490e990fc02e9bb869667731f78d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dce61bce77c27dd518412fe68fb588fb13b85658606ad6febb3ff465009e4529"
    sha256 cellar: :any_skip_relocation, monterey:       "3ccaa37f9a0c0102520b80574a09e1fd487ad579fadc581a624572a2c16ebe7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "360f46cfc7659df7a034d17a297771d5f67422d029ff554ec23269ceb46c76c6"
    sha256 cellar: :any_skip_relocation, catalina:       "445aa00c087a508209f741e537b1b063f44b3f17bdef8573de4852eeafde4edc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d208accfd6de24a4a812cd93cf3a2ebe20b97a219c2ad9395c7d6b0af225ef40"
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
