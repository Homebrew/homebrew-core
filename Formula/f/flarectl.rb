class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.75.0.tar.gz"
  sha256 "b133c90f97ccb90a7f3b7d9e60547b67a384a038702c8854f02975f67315e5de"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0341081e9bb9fe8105e8db1fb38fb3ee5ec28ec1cf49d5c80c7c7342184d182d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c14c1b889e417609a9f605fb40a668a2265380105512ad1b9814c8c35dbeb255"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07fbb90a3ba58b952d0b2d153410c9258187def467adb6f2456f091582ec01ec"
    sha256 cellar: :any_skip_relocation, ventura:        "5bf8689e398c9f28582b867ca857e9f9c4f146cda830908c6cd1ea7aa45f7741"
    sha256 cellar: :any_skip_relocation, monterey:       "0fa951eaf61d1073aa9a3a30be0499ddde663856e78b6970376e05182551bc25"
    sha256 cellar: :any_skip_relocation, big_sur:        "537715a2d13c0b9f4b5f67d0b679d1c3dbd4f52595fa51222e300c3aa5d48253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "897c446855f17b60f1ad36b62836bbbe60382d2e8adc856decaa9f073b6bcf8e"
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
