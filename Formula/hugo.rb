class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.86.0.tar.gz"
  sha256 "090857f8b8ce998d59c8cc9c0207a62ebb3d31bd185d7a0f7f7bb7a20384ec3a"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c61b101c48ff8beb01779f4f3d02dea4bae73de8a5d61b2d14e6d29ea14961b3"
    sha256 cellar: :any_skip_relocation, big_sur:       "f582396fb96def7aa06c29fd84248e546dd03468bc820b5c48ce82545e0772b0"
    sha256 cellar: :any_skip_relocation, catalina:      "4b1f7877b3c2aa0fa634bae45167a055604e5d8a114d53c7239e47235b7518fd"
    sha256 cellar: :any_skip_relocation, mojave:        "3b568c411fd616e714c4ad4ebcc9072211417b693ab1db609dfa49598b0a1218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "194fc473c92e5d23bf866f7cb2812ed9ba22bde032e03b50eeaf136b25ebbd1e"
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
