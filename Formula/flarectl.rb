class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.12.0.tar.gz"
  sha256 "66b2768674b248ea46c6775c5f8f55916459583937606727677a4c7690348f07"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "993195510670b850c0ac4594df0120c54f256954a1d11fd02f51a8eb6dff25c5" => :catalina
    sha256 "5b1b57735271fa6cc84f7578765655971ee7ad01e6a78990ede3ab8dfb29b096" => :mojave
    sha256 "a4e9e4aad2ef65302fada8365d4e415dab16a0123d92185c20983bdddbfa5994" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "cmd/flarectl"
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./..."
    prefix.install_metafiles
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid format for Authorization header", shell_output("#{bin}/flarectl u i")
  end
end
