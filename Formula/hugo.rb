class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.114.1.tar.gz"
  sha256 "789e551db94d1503a1758be850e72326ae8d809b792136b2618e2f41edfecbdc"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "334ce2141bae3a39922cc58161203f064cb566964872c5a101956ef25265c1d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6059117a28218bcf5b268db5605531dcf0894a2054093285839b32d635b12484"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52d3c1052007d1cc6a5684e4a22353b0b48ec032b6972edcba3a962ce027ede1"
    sha256 cellar: :any_skip_relocation, ventura:        "ae867dc7c7cfa88c8f8bf071fff3d57562234576f0ce9897cacc681b071ecf89"
    sha256 cellar: :any_skip_relocation, monterey:       "2076fd5e33da9275689dfa8c2a5c70a1c2c4d698dd073a52012426c30f427105"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8e8ccbc3c712be43a779c1c2d60672bb9443f972694ec93ac5a97c3629685ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55df6d2879c0fb85092285bb04013e4809eb45dd49cd88377cca172bac1acca8"
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
