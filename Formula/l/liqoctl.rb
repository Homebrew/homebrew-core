class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "a019185fb160aa93210b1701dece8571e029a089e213f8c1efeec4ebce18bb48"
  license "Apache-2.0"
  head "https://github.com/liqotech/liqo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e5dc75872199a14a9eaed959561e9f7636c3d6e8eecc3d1485045bd273a1955b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e5dc75872199a14a9eaed959561e9f7636c3d6e8eecc3d1485045bd273a1955b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5dc75872199a14a9eaed959561e9f7636c3d6e8eecc3d1485045bd273a1955b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "22acb8f102c1d790f98fda426fca2dafac426f091a8a11e260e5195961a53e6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4fca3b133beb62f1e2f9be48f43cb1233a743e917f8692b20c40c7e96dec6e87"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[-X github.com/liqotech/liqo/pkg/liqoctl/version.LiqoctlVersion=v#{version}]

    system "go", "build", *std_go_args(ldflags:), "./cmd/liqoctl"

    generate_completions_from_executable(bin/"liqoctl", shell_parameter_format: :cobra)
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end
