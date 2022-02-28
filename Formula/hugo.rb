class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.93.0.tar.gz"
  sha256 "00399bf24e4e1519bae65c6b2c6c60fbd19a33392756121e8cd6cf3b2d1656d3"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1425fd4a49a791331c4e47561ab3737dc60fb0bcd71b6316a71a2d7ab6737b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1caa04e4b5b777ae7f1a362467e1eead2a5359f9dd41ef09265268b3565b4114"
    sha256 cellar: :any_skip_relocation, monterey:       "07f3de3f17560694e7531198778aa5a57f491f9f030d4a911c789089a6ddb19d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5aa98eef5c5cbe13558cdde2269676b6c6e0999663af15b16ad401a126b4d643"
    sha256 cellar: :any_skip_relocation, catalina:       "6373598920cb721c6a38d2919e149b272d9ceaf17dddda617db8bc2bab8e0ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d3d072936fec0cd7038c9f10b590f0364aada7f6b43dfed84c7e900f2b341eb"
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
