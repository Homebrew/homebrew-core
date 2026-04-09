class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "2122507bfbbb8acf71de7d52419bc971381390fd04e732e54a366b28b96587da"
  license "Apache-2.0"
  head "https://github.com/liqotech/liqo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd6323cef002ef81f1bab8a91be5c1e93a4a2b0543704ddcb871e2e893d6e816"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd6323cef002ef81f1bab8a91be5c1e93a4a2b0543704ddcb871e2e893d6e816"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd6323cef002ef81f1bab8a91be5c1e93a4a2b0543704ddcb871e2e893d6e816"
    sha256 cellar: :any_skip_relocation, sonoma:        "281b0c4d3da112c042ccbe19329b9f6cb9482b647d2accf488a63d43f444e4ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c112b86d8c4baed51c84d5399c449db657c036fd4b277193ee9a14378bbf522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3029b45cf8aa44700afceb96f4000285042d7de89a4cf65886abec30e85da198"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.LiqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/liqoctl"

    generate_completions_from_executable(bin/"liqoctl", shell_parameter_format: :cobra)
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end
