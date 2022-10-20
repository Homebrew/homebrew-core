class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.104.3.tar.gz"
  sha256 "f63b3d355326fd71470cee503316105cd2e209e9712b94162bafcac7486e30d8"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b355290c70c54cf0637a9ed70342d289c9f022e4d085e18cb0e4651e3bbe21b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6326009df7c527d3f4db6140212e24ea1c2fb48b5f1c6d772d7402cfdbd4e879"
    sha256 cellar: :any_skip_relocation, monterey:       "3f76b15e1a162509ba7564ad2d0e272a67effdc915e2290d01cab139fa07e3b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "96dcdf4ced2d48b9c9caf14c82fa6eaf6010b4ebdc21d4d2012ea33440d39bdc"
    sha256 cellar: :any_skip_relocation, catalina:       "b1057941b80bc1867cbe5ae30ac7b82fbdb9985fbe8938097d0496950ddf7f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc35c638341b4f3bda0ef4b6354496b93d0236566dd802268890adc926bb3e08"
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
