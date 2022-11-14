class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.171.tar.gz"
  sha256 "e029699857da6b9df9dc36cc46cbf38495af1c13a0610d91f1e15a9723f5a41d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af153ea51fb69ce82d06ffab60c00229ac61edd7966cb910b299771f99ed1daa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "645cedbde6cca6e18653ba30ae17530c91e643edb678453624723cc99d9e989f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4457a2a4fa1a5779a9ca51ae3e476b88b4802d27364d635eb825e803952d4da2"
    sha256 cellar: :any_skip_relocation, monterey:       "8af10d10499f806fc0e8440b6cd576ec8b108963b9d038edee4e590c7c684581"
    sha256 cellar: :any_skip_relocation, big_sur:        "694895bbf201e28379d9113358dfe9ffdef92490445024d1bf088e2c85bc8d96"
    sha256 cellar: :any_skip_relocation, catalina:       "5a83797091913047e1d67dc3923725b8acf2fc73b358877cceb805e0d20a03cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e959b8eb819e946cbf18b9b4eec98974ecb3a44072972a5b1ba1374ee491e57b"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks instead of inet.af/netstack/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
