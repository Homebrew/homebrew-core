class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.92.1.tar.gz"
  sha256 "ac698634f62f397ea0df5bfcbb4ba523743aa5a0f52c06aef9b261224d173883"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61ef470d9df0adaeec63ec5707f144da0523f40dd8dc080b1597c21ef4fbc284"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88c598e79404e0463b8d7198ca7b13ef13a4f712b01ae0d064df537170381504"
    sha256 cellar: :any_skip_relocation, monterey:       "0d57c4f94322abc4be08799a9d0cdd6dcd457a4654254ef924e0981a5122f22f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5da38189608c8f00f6d55f739c0b07673ab3c1d3a462a2075ce54f4dd65743c4"
    sha256 cellar: :any_skip_relocation, catalina:       "f603fa5a0fdb08def108959636222b6557680474a4e4c279ae85e82d2f5f8459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e82de2ab093d21dfb3447d929fa67ced02ef441ffd9d80a50f5b9b1087d0b13"
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
