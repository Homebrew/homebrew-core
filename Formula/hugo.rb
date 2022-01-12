class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.92.0.tar.gz"
  sha256 "3ac140757a7322f0a7511d75fb3b1e77e6a0f0c6e4ea1b0afdbebc00e0d0a7d1"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0c3dc8244a1b98855073c2856e0659f529aaa989fa3fac2622259c8e196e9a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "888559caf902b74d3f8d7525aaeb102e29c1d0da824a4360f7c36c8b5f4d3847"
    sha256 cellar: :any_skip_relocation, monterey:       "7fb768b54cbd6793e8a0913bdc0da9bedfb4c503c04676663aa980d9d0c69329"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f070aa8d114e4d1f8537f307b52048fd2b48d17dc319b3158a6a5e04db3254e"
    sha256 cellar: :any_skip_relocation, catalina:       "1b0791e35fa28a06df5a68a6bb819ce05b50f205555b870749e3ac892b0c3dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6324e2890a741ec750f99b3659cfa57972a186e88374814f004f9f060b14240"
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
