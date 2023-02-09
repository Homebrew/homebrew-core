class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.206.tar.gz"
  sha256 "6466a3956b789493df412a37b0fd746936ddb518a22cdd847cd66067cebeef74"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb3a2e58a7aa9e5d210e69a305c85dc293ed47a65a76d994a14dec6a25d6bdf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d41f32eaf2397166ea93842018369ebc5313253163190c61e86dbf1a9bf1d2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "507fb9973948d2dd70822a930421225ead63998a1c5a26ff9d679e8b3e3ddc93"
    sha256 cellar: :any_skip_relocation, ventura:        "4e11a9f2bfcbb0e57e1ea681e06c4d9042e15b849d169f9bd46279aaf47b8169"
    sha256 cellar: :any_skip_relocation, monterey:       "c9e9d27a54f8ba61b4da9004fb1a90ff0d094b829243b6d36b12d690b55d8eda"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b6955765f804b2b794ae9c95e6ca16b95ffc02f2f781abd82b887bb2fad4368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91358246d5b3abc9a79b60f4ff9dfe70d1518e4c3c8b5dbe2defa1e90d6346b3"
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
