class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.89.2.tar.gz"
  sha256 "2fa4814f9e08e3efee3dbc37281309e359cde10e6b99785ee161c0f35c4509a6"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "481f074802afe4721bec0a1b4719d1c63f58fd01232a6819dfed18285148ad1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "027040c91421523a42a7963e4ddd2e57328c8cb3d7387d6796d2e63a074ff9c2"
    sha256 cellar: :any_skip_relocation, monterey:       "b48d16af36ee66f46d4ba5cf3e846fb5d7a68095d2624dedf3d6983720e57071"
    sha256 cellar: :any_skip_relocation, big_sur:        "900302c204ce51fd58047de720252df9ee1b7e9351f8aed344ff7cfefe4939c5"
    sha256 cellar: :any_skip_relocation, catalina:       "ed110f489aad4fa745b328c8adb7bcb7f3fc23513c387877e41753407bc1759d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd441ddc81be8c9a845c0f4556a34a4b0e48f46d20c20292e696d746b5923fc4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

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
