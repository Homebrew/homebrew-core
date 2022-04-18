class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.97.3.tar.gz"
  sha256 "64e37b418de16214c2c5df6d250980101bd5f5aac8721aa2ecd707980c5c6785"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "185c6bce2bf27d61cba1058a4c8c6e0177c713891fd85209dc0483b7153b784f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b6c801859520881b7c5ad93f63f834d25bb3ca45f2010b1004817a9a6b2b7fa"
    sha256 cellar: :any_skip_relocation, monterey:       "b549b52fb11a77e0d593044b34e882642aa4bae1bb7a15660b344a7e94709f1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c357095d048d0b75484c23a3f706a6ef9c9ce762b7a805121974cac1ea61512"
    sha256 cellar: :any_skip_relocation, catalina:       "993ae1b92e2c64c459d27138f3d04ec40d3272a1743b086962d4806c0243cd0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc74d8c6d497e1b8a96452ba2666990ba341d9364d9f751378818da8a9903e6d"
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
