class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.102.3.tar.gz"
  sha256 "5fab29ababef5294c891d687aef027c423771d4ad33af10c69f18ff9754d283b"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7141007274cff93e66bb79ba8e2aafe140a6cf21f93459564592efe48496cc61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce5425499925096557fe95b80745ac5c2e8783ff721cd5d9d234e7bd94c28a3f"
    sha256 cellar: :any_skip_relocation, monterey:       "d15f05183b86902eaa798c89f60a03879080d81e09d0d79c16897da43153c9dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9139c2a2069ef55dc2b15ec7f98ebec29e96ee63fc143580b1cee1889796777"
    sha256 cellar: :any_skip_relocation, catalina:       "b42cce069e9c9c5289b4673eb8398afb1ef340a211622085baea2a35006fc1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4ae8579ad91b1afbfecea13f71509bea759f4fff9226be5148b4780866816e3"
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
