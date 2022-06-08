class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.100.2.tar.gz"
  sha256 "651b0fe2c2c97be016066a6fcb53ef262a2bf5237cc370003a75489fb64b0a25"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84b73775555e7f37b2fc8bffc7a28e85404cd8f5534eebec46a654efd161d288"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0700ed48b05fd55f00990afe1878e35224e9090a6863195635d64b33af9aa957"
    sha256 cellar: :any_skip_relocation, monterey:       "99978483194d828d63dee2a2c998e91ef1ecb4d65da7385f40ea3502e0e353ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b38ebc6b23ec245b852d20269a0bcbb006bb2903c0a538e1bb360867572ba34"
    sha256 cellar: :any_skip_relocation, catalina:       "a89a9214785e269d08f5852803a0ef7e63751ae75203f7bc211f9196c263ef24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17a344c0e715e694ba6767855c99f224410ac408ad56d1a65c5c8b359e76850f"
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
