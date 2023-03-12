class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.111.3.tar.gz"
  sha256 "b6eeb13d9ed2e5d5c6895bae56480bf0fec24a564ad9d17c90ede14a7b240999"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1853a99559b34dfd9050897c756f1e21bf8fe26dd43c72502a8b00fae0e041d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67c65784d106e4f5dd96bceee7f442892b3e1b941e93de3b0fbc1c2be9145fce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a98e1bbe1dc07730f394ddde7965d84e88cc110bf1ef3b49b980548175cea1d"
    sha256 cellar: :any_skip_relocation, ventura:        "f8e64d6366310fe183aa54c92423e5117e5eafc47b10a1ab838b2c36e478b937"
    sha256 cellar: :any_skip_relocation, monterey:       "17321ec697214eae368890db311deccb722d2f7eac0a917328fcd48d14fc38b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "82eb4cefa0a37b5f3dbbc100dde2fa994c74aa3dffe9194744dc6e60d6d1d76f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5fc1d48a4226acbb0b1490a567828d785cea9ede5e5aac5b57043c11f1861ae"
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
