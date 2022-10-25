class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.130.tar.gz"
  sha256 "7b21dabcc905a6674a473a4ebf9752366ef02f9edab4dc5fa4d24c0e80a7e383"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fc853a4e86ea10f958ad67a6200ab9b5e98cb172685bd1a25d25aede837f9dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16fa2737464d3a10cd4f475c90700dc138c12b1bed4eca83d403e9bb2e338eb0"
    sha256 cellar: :any_skip_relocation, monterey:       "9772b84dc3b2a72e5bb3a7928916b919e968c6864b6c72be18154bfe2b608ee6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5860d10a3be2b83cd776d4b1a451c0284bfca81bfb64e5c9bd1f1228cb0ea782"
    sha256 cellar: :any_skip_relocation, catalina:       "5bd5c17799b8fa0403bf74e013d3d7265c7244acbb0ae79f707d32b89afe1421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b82f3145ddac6d3f22fb83f1186da90d89b98344ae9c0ab48ef720443339d52a"
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
