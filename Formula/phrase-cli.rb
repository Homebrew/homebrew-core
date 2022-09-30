class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.5.2.tar.gz"
  sha256 "4255ea0c647168c61d1b37a0dfec96b585f0bff4fbfc072b8d8d521af7fdd1bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21567cf409d483e9699c26a8110b369b14ee8884a40bc81c3169da2d0600fcde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18aefaafdde4b1510249d2bdf3e4c02abd265df99022f702ce0969cb1c078089"
    sha256 cellar: :any_skip_relocation, monterey:       "6a7d45ecc960cf38ef82978ff899eae7ef9c6622cb9f6473d1fae68462614bb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "942439f06ffcd9d68c8dc3036bfb59e6925691cc822269153d3df2182bf49b09"
    sha256 cellar: :any_skip_relocation, catalina:       "ed43a319ad3159ac1e680e96b3f1f5c453300509a651b257477100b2b639e7e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a609d01bbebae72f1e21e1f642fe2e1ff4754e12a97de180e81c45b3cb4121ee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"
  end

  test do
    assert_match "Error: no targets for download specified", shell_output("#{bin}/phrase pull", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
