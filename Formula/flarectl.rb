class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.34.0.tar.gz"
  sha256 "4ec0a0f1d27086a5c62fcb4ae8c4d914ae2904ef71e8269aaf0ebd35b498988a"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91881d21049d4a1a53115024fe07b91f66cb4c0b30d18bb827074bebaca193e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16194cb15c0b21993d16a0182d11f2172bbad15c5120b9b7a892fa9f4ba7204f"
    sha256 cellar: :any_skip_relocation, monterey:       "82579af5a850aec36951c17d9e817a3aeb8b622c2a2f6452e9d3e17b82c02402"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ddc4a897648dcda062801c90ef36d26822860648a19640e9b47679a4b75bacb"
    sha256 cellar: :any_skip_relocation, catalina:       "b62812caaa6107d85702243964a7180eb8e296cf378f83d93e3b9290a83cba82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52b4221a63f0ef2e625fc2a26945af20568e7dec87329af38187dfddf1817110"
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
