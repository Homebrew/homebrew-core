class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.119.0",
      revision: "b84644c008e0dc2c4b67bd69cccf87a41a03937e"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ac0dbb3ddfdaa6b49f8181e01d684b0adcfe469619d0548775f00cb1a6f0a91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5284b361f9b93da3fbadea28ac088f60454fd3755ee28f2b14123ec47b096d37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a69d890057b26e34a110e068e7e84eaa85b261d5116f97c699a9b5061a674c17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf319e6f40e96b89245a0846537acc8e384ca02ee3c79257b34638097d901ca6"
    sha256 cellar: :any_skip_relocation, sonoma:         "39cd6b3521da62f07405541ac7a45a6bdb14a981a41b63126ff30c36fb88a5d4"
    sha256 cellar: :any_skip_relocation, ventura:        "b2f225e4de63c0b03ddf78a8d5f899c361b6bd3910d27eeea566cfc38e0a85c7"
    sha256 cellar: :any_skip_relocation, monterey:       "9d44ac6bcd64975231bf566e6e4f376848b51ad32482e4fb537f3524d210a799"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f17d49586efe0b208cee347a9ba3d733b805ddd9e77e62eea2bd2ce0c13074f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74ed350fd96be4fbf11f7f7c6b079838973fa010d1e17d22746d8184644e6751"
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
