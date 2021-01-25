class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.80.0.tar.gz"
  sha256 "4ddcd6ebea21e5fd4067db4a481ab7810e34496d5991a3520169c8f5ee1d38bb"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "022c7aacf9810cd764fb854a6e206be4514f8a0952f72f1d6a2b26ec35c40e04" => :big_sur
    sha256 "33de4b0b3b0dff2a5ef783f7038eed25398eac1b0828949c67393303d13fb3ea" => :arm64_big_sur
    sha256 "45fcb8c9f88294834b1b4f13d7540b17e29364be86c87d7115dd562c1552bd48" => :catalina
    sha256 "9b21c8f51cf6bd0981b9aa539027d5e170528c350032c977dd66ffc8bcfbbf36" => :mojave
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
