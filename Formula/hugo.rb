class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.100.1.tar.gz"
  sha256 "030fa0a75005dcdfd0b1ef3686859977d234d89d6d73839e7ac8695262aabff5"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d622981916a5a892d1cce2646e09bc79c9efdaf534fc494575dca6083077bb67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d10ddc86f10725713b95994f5ee676f9bd6e71f6d8c01c517e40e74118c95240"
    sha256 cellar: :any_skip_relocation, monterey:       "36f55c7b8bba0dd62236739eca383c896c94e23a957e9616e3c9cc165e8acaf5"
    sha256 cellar: :any_skip_relocation, big_sur:        "02bd1500ab2994a09d2abde41ae1382fbe4ff17d31909b6c41a8d6fd1a953ca2"
    sha256 cellar: :any_skip_relocation, catalina:       "66b1d3cb7a75c264f23813760fa004d096bcaada8f17bb3ef11cfd8c554a2ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6022f0632b00237810837842bcc147f0b82590e3dea08a6d62e9086ce00bcd39"
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
