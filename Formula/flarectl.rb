class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.25.0.tar.gz"
  sha256 "8dc7a58c9e0f7d74a2a89da0f6aa23e8ebeee67838301e091354fa3d9760cbb7"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "15b60d314c3b8d77356a1b004bc97ed0fe547497dd878f11fa7d6c32b306c932"
    sha256 cellar: :any_skip_relocation, big_sur:       "7abedc87068b4c5041e275d48ee375682013d98bc5b47786a7e02f484e83b382"
    sha256 cellar: :any_skip_relocation, catalina:      "e95ce2c4f61afe4bc7388e57b2738103e5b537b4f6618331b2a25be9e0e0065e"
    sha256 cellar: :any_skip_relocation, mojave:        "2976e801e1f53d00b12e05487b1ed59737a8b63390da6b65c9914e03e1c85429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3639f316cec5bba82d02e94649ae935de449fb26ed046822503f910eac84995c"
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
