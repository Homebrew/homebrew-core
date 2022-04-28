class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.98.0.tar.gz"
  sha256 "5d993c81d98f88d89f38fbc7139d7d26474c32f344bc220abefad99a66ffff9f"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83fb57f8ff09e309b6755e6aaa00e6f2f14f86b7e674c9af589f017fd72b184b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2c6c153ac22bae46689388835943293c7559f4208fc3694e969b477b57a2e19"
    sha256 cellar: :any_skip_relocation, monterey:       "774f54e514ce83db0727a92ee84241a92600e47badc75375848d9a1b72e7ad0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "91d425d92780f95cdaf1d5dda18a9cbdad2ebcd121806a91763241fd58ac81e7"
    sha256 cellar: :any_skip_relocation, catalina:       "5d078e05e45d1bbb0b36ef0857b2a1ba18010a4ba1c9fcc106e5f9a59eb898cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb5ba10269e36840952773a192dda9538ff67d285bc36ad873abf2ed20c736f5"
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
