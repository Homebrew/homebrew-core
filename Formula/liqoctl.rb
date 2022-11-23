class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "6139e9cf9d85a9a0f5c6b1ea6d05e911f88a8c45228c709a1f3f3c4d88b955ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c7e81e4eedd602f1d7d7c71d41961e40b7a793baab5a6b60a76fa398b5a0633"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59c5a1da586bd68ed7007522ec252d03d1770434777d402dee3cbaefae84d814"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59c5a1da586bd68ed7007522ec252d03d1770434777d402dee3cbaefae84d814"
    sha256 cellar: :any_skip_relocation, monterey:       "aa679259aa9b953fafd0ac3ac9ea565a2ccca03b6516d6cc69728f660cd54e62"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa679259aa9b953fafd0ac3ac9ea565a2ccca03b6516d6cc69728f660cd54e62"
    sha256 cellar: :any_skip_relocation, catalina:       "aa679259aa9b953fafd0ac3ac9ea565a2ccca03b6516d6cc69728f660cd54e62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d68a076805d8f97d7544a21146e4df26e6c358df2a94aa28bd887b639055621"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.liqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/liqoctl"

    generate_completions_from_executable(bin/"liqoctl", "completion")
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end
