class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.47.1.tar.gz"
  sha256 "c29a08fd48c89d93c419a9a791410d4fa9d00f596b0f855c9cf2e5dee8678c3f"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57e11f21f057051f54cf66f550be58853166aac1f111673e9d7d43b012fb77d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee697b04608a6f2f96d7a400f5f5479d4f6b86d4db83c93cf37e40fdcc2fce34"
    sha256 cellar: :any_skip_relocation, monterey:       "76befa8dfe546da17d35dd01e71400fda61af18aeb2e57745cba32ef310eec44"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ffdd93d4a5eb1a0559aca238b911095be5d71259f85b2b0d97ef497073fb552"
    sha256 cellar: :any_skip_relocation, catalina:       "b56bc4ce3bd07d92aeb1e9346490f894d8b32cecc0f276d05148fe70585e8c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a589bafe1bd2ce4d6b2fa53098317378974b9a1278975b252beba1381e36a24"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
