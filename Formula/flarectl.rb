class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.22.0.tar.gz"
  sha256 "2021854e6507bf7ca1fcc5f767d9e8614ba9d1c48e637b6300bfeff5d6a6e59c"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "be9d1ea465bced604457b328b4036d091ef17e42e54f0e29bfcb11ddaa052913"
    sha256 cellar: :any_skip_relocation, big_sur:       "0ab0ec28ae4c7657ad8c4fc9569399c26fa66c5c1b6a009169d7068c1afa098e"
    sha256 cellar: :any_skip_relocation, catalina:      "a27d3680265be3f5979e0feb349b9c8cbb6447e828fb23f9cc8664c709e1e8ea"
    sha256 cellar: :any_skip_relocation, mojave:        "7905ac8302b690f1be2d7f54a17acc51932ffcc20cf8aa86fe84dc35d0c39690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b028e40f80d855f9e73305be643960469af64fd8628645d09d23e33167593c9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "HTTP status 400: Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
