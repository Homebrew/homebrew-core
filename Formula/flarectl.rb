class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.36.0.tar.gz"
  sha256 "2a453f021be34a9406e91f4452eae6138e8355f5fa30cd140560dd995177ccd5"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b9620e9aecb1a449f37297d4a3cde2102a0cbd70186bc66649ce479205afedf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c68abe776c0797bdc2920f11b1b1b16b8504d9bf77864f6ee0a228a842cc7ce"
    sha256 cellar: :any_skip_relocation, monterey:       "49ccbff6d3388d76517429d8af3a86bb5d27c02a7d7cce0b36f6885349f3faeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "b92024ac17ec99978c379acf3d58b4b2766edc355d4554de6d0420d2e6a1f435"
    sha256 cellar: :any_skip_relocation, catalina:       "13a1e7141c1f8e6005820cdd6ea117f890d3b93b2b41d198663d5f251c5a9cce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68e368ba1636a085f356c74c0d5a497b491fa8a455e20b3778953e97a1783b68"
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
