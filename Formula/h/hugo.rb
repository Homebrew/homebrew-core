class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.136.3.tar.gz"
  sha256 "3b1b5cc67b6fcc3ea59dcc05f7e84982bb0111b354007b3a7d078e7fbfd49f62"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8be51d2550138b4556612ae45ec0e989977d798fea9625e008109d8212616462"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e51115a158e94fc946bb4479dd9a64f8691c606e9680544e3727e694fa39a0fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f25b2d748f4a3ce45f93a9accb52c506f20762ba87db7365c6cf65705a8d18c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf7d433d5600f85ef048f095e18e8fa705c0cf5f7f742b65e6a70f5320b7d0b3"
    sha256 cellar: :any_skip_relocation, ventura:       "28fc09a444945fe9216ff2a5f7daad8aef9343df76226459a960f4789975fc18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7cf360613d531f3ba89871d04c02877d6366478e8e350152580bf95e1676148"
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
