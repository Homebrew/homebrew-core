class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.149.tar.gz"
  sha256 "1ed8666be04f780d30c2a44b01aa479fb0a16a6f5d5687a237a6c7e9f4605a07"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12c28302727338240b8127656833f0f2feaf40c2f244baf5b7f7b1d2ff553a0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "762ff24386de8a0df2f59e580944423fc0a118d1995f39995cde80fae73875b0"
    sha256 cellar: :any_skip_relocation, monterey:       "b23ba59721b0248c6167877320062ef5c0c71b8fbbd454000d3c69f7e99a97bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fcb2ae4a4ffc2ff59cc2277a826f865ebc32e32eeb4df1467f327fc0e50cb68"
    sha256 cellar: :any_skip_relocation, catalina:       "5cc6b94c089a1ed8408efabc57663e1c2f40ee638f952318d6f3caab2ab8b996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd59ad4f740c7c87af4a5969e156a0d0d3f1f0600c70f897b2b5be49605b9366"
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
