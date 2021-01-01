class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.80.0.tar.gz"
  sha256 "4ddcd6ebea21e5fd4067db4a481ab7810e34496d5991a3520169c8f5ee1d38bb"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "276cb57cf2e4d0a3ff1a7160043578d8c743d2b35f6aa7777b6772641acb0cf5" => :big_sur
    sha256 "650beb3d01c5f6e03f33387573e3e7d3ec390aa61e86cb9e2dad964256d89e0a" => :arm64_big_sur
    sha256 "9a177a3e54867523f10c44522cda5c3666fd80cbdfb4238d0ca0fc2bf9684ac7" => :catalina
    sha256 "afee3eeab8930928a9b7656f09826dc2be8dbcd112558a40ca08f304f3e07e00" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-tags", "extended"

    # Build bash completion
    system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
    bash_completion.install "hugo.sh"

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
