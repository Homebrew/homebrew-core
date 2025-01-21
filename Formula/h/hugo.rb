class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.141.0.tar.gz"
  sha256 "98339e3187cf868f8a01d14b3758561bab26540765b749abc23ef52b04940eea"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29d36cccd08be0b2debfd9c0baad40412aa5da73ecf17dd96fdc6511c54aac88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f38ea3ebf2e788af640872b11d4a84a9b3f18ef68a46a11c6f5cd810a1c4c501"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff29586cc93f7c38e10e24360afa28b3089e6c350345fc31f9f7f41d2b0aceb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff9a32d8e783e0f7fe27dffe47f01749689fa5085b39f2a230912a008c781d35"
    sha256 cellar: :any_skip_relocation, ventura:       "9aca7d48958ad23cd82b61b56169b7a6d812e0eb609bcc70f0fa22e597502101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e4bf49ee27191a6755ae29fa57cb66f01e0f2ab802fd1f918e670c90607fd41"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended,withdeploy"

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
