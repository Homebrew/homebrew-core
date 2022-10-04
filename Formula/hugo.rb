class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.104.3.tar.gz"
  sha256 "f63b3d355326fd71470cee503316105cd2e209e9712b94162bafcac7486e30d8"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb7f6d0b49f7c7248c820665cfed5b0b9824bb19e61d8f19192eef0ce106b384"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c44adbb29711ab1715b92ac479c927803a07c89e5ffb5a866a25eef0ff4611dd"
    sha256 cellar: :any_skip_relocation, monterey:       "81bb363935d392261c02f96674da036259218d04b7cbc9a3e1ff26d2e3a30330"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc77e930e8dc0f7740d154be048768fcce92425912e8abd6e7987d7500ea3387"
    sha256 cellar: :any_skip_relocation, catalina:       "ccd1f74c8de246ffbbd4710dbc00782e0d78c315503460e0f6a89b95c21bb224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5ad94e62cea516e4899ff4911bd34e269b2e00ef82a4304d667813a47bb7d3a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")

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
