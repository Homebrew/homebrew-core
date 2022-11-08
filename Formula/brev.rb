class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.157.tar.gz"
  sha256 "780fe28554a02783c607cd71e60d1c14ecb3dd5e2bfff9693bec099a84685065"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "000b973e2a0e8ff1822d75e4ee519cbb85de7c354af8198501e57e126b222f91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a0fe8a64d93f3bc32c3276456980a2c3b8bf80ed51429acb72b1146cb29f82f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "457da6a59b7dce668354634610e534421e44bdf09fe6d4539e7f482599475b4a"
    sha256 cellar: :any_skip_relocation, monterey:       "76441cacf155d5d53c8514111c2b94be7cc191ea10c36c7edc7ee750a0397e38"
    sha256 cellar: :any_skip_relocation, big_sur:        "fac40ae49640092abd922dd05074d0a424569bb5e19c4c84eb1c3bb0499bf253"
    sha256 cellar: :any_skip_relocation, catalina:       "935d59e00a197719f4f6497c8b11bfca2ea156f81e82895c579242ab894d967f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e017a7ea8a02325bf71bebd1692a22428646bfb5045abfb66d1693fb977f6d33"
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
