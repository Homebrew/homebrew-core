class ContainerCanary < Formula
  desc "Test and validate container requirements against versioned manifests"
  homepage "https://github.com/NVIDIA/container-canary"
  url "https://github.com/NVIDIA/container-canary/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "3f0ceab899931d221f4d88ca01783d98446198a04ce56c8065a111a78872cff6"
  license "Apache-2.0"
  head "https://github.com/NVIDIA/container-canary.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f05da274de16c17ed5b55914e94aa49245b13947f2684c45bb38241a3b64923"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d8aa6baa36bc85bd7f15afc41f04bfd76098b1e9d5f682ea1ea35a2373db933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e092b3c8ee848f790f0288d740df5b7f52148f017fb32701c58f8884970593f"
    sha256 cellar: :any_skip_relocation, sonoma:        "644611fee14fa1426fbf69f998a4090763e39542e957146c21b5f65d80cde033"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c605a4323c42a1525fda0f8c1252f9ded6731329219aeadf9c782751731339c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fa7d10e14e625b54c9b2ea110d3f4db00f62293f944c764f3b45257425ea6aa"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/nvidia/container-canary/internal.Version=#{version}
      -X github.com/nvidia/container-canary/internal.Buildtime=#{Time.now.utc.iso8601}
      -X github.com/nvidia/container-canary/internal.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"canary")

    generate_completions_from_executable(bin/"canary", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    resource "awesome_validator" do
      url "https://raw.githubusercontent.com/NVIDIA/container-canary/refs/heads/main/examples/awesome.yaml"
      sha256 "7f5e2f78df709d4179c1ae1b549669f80a4307c4f698080fac27efae96b02a42"
    end

    assert_match version.to_s, shell_output("#{bin}/canary version 2>&1")

    testpath.install resource("awesome_validator")
    test_image = "busybox:latest"
    output = shell_output("#{bin}/canary validate --file awesome.yaml #{test_image} 2>&1", 1)
    assert_match "Error: Docker requires root privileges to run", output
  end
end
