class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.135.0.tar.gz"
  sha256 "a75c4c684d2125255f214d11b9834a5ec6eb64353f4de2c06952d2b3b7430f0e"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97918a1b5b5d4101a3fdfd7b0c0c582d94ca1dcea3ec0fa301d3d9c7cd8d30fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0362813870f7919ec9a3f2e593aa7d7cd3ae036545f727280e7ad49d6c34cd88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de967c89fbe8c8a57aa0f265fe68dc2759bc0ab7ee0ed6738888b4f8c60377ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "712ac920d16f1409b0949c2e281eeb1e04f7723520a8c344035dbd21bc13e681"
    sha256 cellar: :any_skip_relocation, ventura:       "27f3c4c5ebf4fe1f7f5ddcd05522d0694988a5e84635895a8b247f8a26adcbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66ab34fd84f165604092717c8b68e38cdabe4677ec6cde949075d0adae6d07a5"
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
