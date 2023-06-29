class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "74e371dd2d9f7dc3d45adff8eae20e45bcdc420c3449cafeeb6ee01e305c04e0"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "136d6725ef81253ed96436c01b7ee6795079fa1ce31576a2bba8141f2084a878"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7465647b2756be5c63a778f1b47183650d05547c44391f345f961341e482b65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af641d538a87f8476ca7e17d2115c672b4495a54f0d594ac1ea1b285b2e556e8"
    sha256 cellar: :any_skip_relocation, ventura:        "746d078d1c9c3c116ef2e40cfee8c78bf0f6756f0461b64f0d4878c896820792"
    sha256 cellar: :any_skip_relocation, monterey:       "7e559a24e82b9fc97a364c6a8e83aaaa15bee7c7d7a0463a0dfe2276fda91c2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4e55a36f70e2ba385756b392eed8a3bf24ce0769dbb03117b006fcf5669fedf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10bffd8b529845f17d43e1b4715d08894ce19bb8b65e385c1117ac0bda15f450"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end
