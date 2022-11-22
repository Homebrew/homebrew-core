class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.180.tar.gz"
  sha256 "2ae0a2964388ff3711892e419e17442c7fe8e3e3da46717e8f1e682c0f9e7054"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f41bf8ae2396735fbcc5de1defe9e6010f616e4f225d45329e73eca24de6946"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dfc11dda0b8dc54787c9daea52cf016bf6077d8e89e6c9abf0cbee2fa083567"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cce91adfe9462deab72dbcf17514fd324ae7a106255a5497cf3b2cb59a2184f"
    sha256 cellar: :any_skip_relocation, monterey:       "86ee57cb5d0fa53a9ee5f3121fd98334c65f0a4d363db658ddde6209958ab061"
    sha256 cellar: :any_skip_relocation, big_sur:        "a107351cbcc63fc35f2a9a2f5deff3398ba5c67120aa7b3d784d81bc298f2df8"
    sha256 cellar: :any_skip_relocation, catalina:       "1656545548211c0f6897cf3b5cdf8c5abbd598fa1f429cbf3dba076828a21c00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6786019b1a42512efc7d3b73877b7c17b7ba8758a362cdb37d5c1978f94e9082"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
