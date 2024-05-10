class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.125.7.tar.gz"
  sha256 "3c931fab3ee9fd2f48d49514d9fbaadafb1609925475aef4012db9cce6bb0dad"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "136fe38f237c5ceedd40c18985218cfed3cf9e5ddde5b3a82c867a1f306383c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e68d4bc46a1b1d0a895f979f5f76ac9b787bd53792b3db44338f2440b74f04f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc66bbcbe3e268388e89c5d06e15f6e83a4863b7621f1a0df3a55d33f170ea74"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cb66692eaeb1b54222272b3bd800ed8641cc4329bdb0214d6b42ab8526e14ca"
    sha256 cellar: :any_skip_relocation, ventura:        "22615de19471231ed876bb2014ab06430374b8160065f835f57dec99bc0c40a7"
    sha256 cellar: :any_skip_relocation, monterey:       "a022f8b393a69fe9c442ca7e70cab5ea34229885f411912c049a854473c33fb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85d2ceaa259a8c99ae2e6e30ad9793d1feb8c7388a8347d443f0f43935194f72"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
