class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.123.3",
      revision: "a75a659f6fc0cb3a52b2b2ba666a81f79a459376"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfd62bce702c79a21c46dd2c3a5d0ae3083f091e3e98367abc470f5f120aa367"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2117c5830141f7d24b3ad56665668e67802dfa0bab64b908cae62690f498328"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3b4a5f6e098b2ffb1abe82bf898ddc10e8045b3f8754851dd88a45bcdd742d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "34cf0c582792ae14bc9930656a4f8b7f6fce10034269c394144b16568e1af1b2"
    sha256 cellar: :any_skip_relocation, ventura:        "87b3f95669ab7fe8affecdda0abe279b5dcfd660f4644467e62e6a25c54e57ad"
    sha256 cellar: :any_skip_relocation, monterey:       "a8f70a38b16a0f8b25956e463ba0dd55682fc641b3559f5c400cfb6b289d4f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8eea84db5ac928aac2a0242f5265e675787c544464d50a416e7e3fb8047da4f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{Utils.git_head}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "extended"

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
