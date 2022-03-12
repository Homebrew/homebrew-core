class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.94.2.tar.gz"
  sha256 "315bc0d22977e84ba25125b1d23333648e36194a46a4d6ae4f4c6c683dc8979c"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "650985eb8967555b5d65164d0e7457c29bc4b795af7ba7bebe1d8bf8d85dda7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9edc07415ab2e7e8f375a145ca8cdff45b722de699efed5fe16f7db92be6331"
    sha256 cellar: :any_skip_relocation, monterey:       "f650560dc0aef2615b14f56d27c3e660f7b754da6fabc69e130d0e826ee554af"
    sha256 cellar: :any_skip_relocation, big_sur:        "92eb80c53f1569882188feb7cb50b4db979d5ecea341a53d9d71a7fdd1c9bac8"
    sha256 cellar: :any_skip_relocation, catalina:       "fe7dd3ac6d785b3b1723da85b22d7e6edd922441e6019c44ea54e46f97a2e2a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7779f0c2b12ae81c1990cd03910faebf0afe4992f833fe38e6c454c27fbcbbe1"
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
