class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.99.0.tar.gz"
  sha256 "7ad1d95c3fc9c0f880ba6fe3ff699b54bd38f7b2bda8e3706b087d368b7b77fb"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a2888da63249098e970999fea3614c2b1a4ecb48ca9f75e1174b0469239c6a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f8f9f78fcf36e5e7c8411460de9c07bd1c2e5f43df880258e26ca9a40a34210"
    sha256 cellar: :any_skip_relocation, monterey:       "ed877e54d75ff23d90e59cbefcdff8afaf9617fa9c8e1ea457e01226f6d3020c"
    sha256 cellar: :any_skip_relocation, big_sur:        "94c45270c072a2ebab78910fb4fd2dfeccf7aada4c5627f31133c9f4f0cc0384"
    sha256 cellar: :any_skip_relocation, catalina:       "08c97da67ea263b5fd28581124ba724def818a56cf8fe1bf97f0c3b1c16315bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94d8b5d6eec1938c43c91c6e9450e167b65b9010db82bc740173d0dcdef2c4e9"
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
