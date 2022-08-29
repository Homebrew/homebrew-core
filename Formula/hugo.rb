class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.102.1.tar.gz"
  sha256 "88c3f4c4b1211b0740c0a15af99cd9982a8e5b3f4de2ec3f867d47082571ee91"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8b18ae5b28a2cac5d6eefec734ef22a35acf84a23df087df9340bbf2f790f83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bbd6e3bbd99acf085699db2e70bfce2259aed51df4bcc5f55b1a4d4a0a98acf"
    sha256 cellar: :any_skip_relocation, monterey:       "df3ac21c9a3466224a03480a08eea9216b43ab501e2922baba8990b22f3d3200"
    sha256 cellar: :any_skip_relocation, big_sur:        "285525afcc1b9f38f73ab335208cef2eff942329aa89af58a835c4b8adef0091"
    sha256 cellar: :any_skip_relocation, catalina:       "5f551c314b6a2d58b7b9661fb62d219e37a52de72df856e044ea576df87888bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3475e23010ce85e3dfe50342479709e16e9159ed053646e8a0008279010b3c2d"
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
