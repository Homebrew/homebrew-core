class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.113.0.tar.gz"
  sha256 "0bea01f37d7d04e6262844ff3070b76e5fb9f5fe2330a1367bd1c35c77098161"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc031ec189de5dc4e7ea9314c5dd56a510c3e81ecacc96e08d95ee997dec42bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a52b159f327ff7a70caf23419b5fd836d4aa70598a7db9cc087c9b1bbf1e6d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba45784494b64b2ef866ee75983b7bf8f24168dd93bf51971df13c68a26cbb19"
    sha256 cellar: :any_skip_relocation, ventura:        "64c9b180f6f7f91f23e13f7ba654abfadf5709bf0aa965be4536456617f91066"
    sha256 cellar: :any_skip_relocation, monterey:       "a5011cd56c06120dd5c9484fb0b2670d0431952fe691f9b2d30f39dbf8ba0e85"
    sha256 cellar: :any_skip_relocation, big_sur:        "10154cc948ca1c6b035b902c3c9f566bf921d0cd3ac01b08808d5c297208ce75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "391a5376036847f8d632902848154a340e0ea48dc4d5c419c4e48fa8661801db"
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
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
