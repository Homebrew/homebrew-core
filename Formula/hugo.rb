class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.93.3.tar.gz"
  sha256 "6fbd5b4031c3f8fedda8a888462b93b8dfd1d3f3d8bbc0dac670582c7dc89f4e"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fda90210b196e0242ae1c9d7954ed9f151345b0e89b74d48b859d95bcfcbf2fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e59fa027aa98f1071d132e02ba423412ae09a4c9d9e180b168209c0c7eac2e77"
    sha256 cellar: :any_skip_relocation, monterey:       "e7ae4c70372ddcb09213c69ba76861dbb8c95881147d4628e919cd6ecf49d74b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3602dcd5a5fb39b5635c1bcf32473e9623c700aa95f9b1f9b7c5c924b43f010"
    sha256 cellar: :any_skip_relocation, catalina:       "b46da4a7250868b36ec65f6b84f88fba3776d9b6e914189def38bbda2dc60ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4924f623a3c5b85eb225e2e47351796995c7f2d441e53aa779ed44c6395607b"
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
