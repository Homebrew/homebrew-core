class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.139.tar.gz"
  sha256 "2f5a5755ac454ccb0120ef65120ec2446e8a5d376bbdee656a8c40dc427765f6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61b1906a74bf39d9620ff1299fe8df8dec766a1d9becd7cd7a9034dd88bd780c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68f11291e4ea360dd20a23a8c2f6534efc698d2fd294e6d4ebcf713e589c59d7"
    sha256 cellar: :any_skip_relocation, monterey:       "d36c23939c1700d1b9542cd37fa610931508e76bbca508e1625eee309ec7e775"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1e5c01e978f416ee7c9204be81edecd5b13ff4fd625b5b78087f64991e09b1e"
    sha256 cellar: :any_skip_relocation, catalina:       "4c0798115f0fdbbb50ead09b195c7dac929ffa69b75fe1af8c37587279eab678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fb574099cc6a1642fc839d7b0563ed899fcb40cebfdc5bca8d50cdd3cca62a6"
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
