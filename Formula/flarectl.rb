class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.65.0.tar.gz"
  sha256 "4d350fc308d868d31468ad9c8ecfc31ecf2a97ad7f77c665a955595aa5654341"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c4cdefb1dd1e14d796ca83aab3597df2547d41434cf859ab6667da06d9e0d2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ff4f59a7d068a9557c3f01b32ef887761686aaca488e613c626a273c3d18c81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72b636e9c2193837279e7f4404a4138464e8bf79a846e4ff56966c1976be0b8c"
    sha256 cellar: :any_skip_relocation, ventura:        "c2c40e18189e37a6dedbf8c75796ed8181bf65a95798fce17b0d4f804f4d0732"
    sha256 cellar: :any_skip_relocation, monterey:       "eb1525a416c4aa2e7bd5555fd5ee43fbf8b8d03ffb76a33d9a01b2ac76647076"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3769cbb1349540480a8282bd34c6b96a7e6dea73786a65e18bc029ac5363b69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "614bd4abf0a9eb4667e99674c275f4af731b9130c53f1a76b9aa43fe2cb8e8cc"
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
