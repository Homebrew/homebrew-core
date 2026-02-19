class ContainerCanary < Formula
  desc "Test and validate container requirements against versioned manifests"
  homepage "https://github.com/NVIDIA/container-canary"
  url "https://github.com/NVIDIA/container-canary/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "3f0ceab899931d221f4d88ca01783d98446198a04ce56c8065a111a78872cff6"
  license "Apache-2.0"
  head "https://github.com/NVIDIA/container-canary.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcbdae7844f8bce0c68e61297e385395bf4a2d7796ad9006a339b7c981d71ac1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0f3f8842347f850a77c1fcb74699751032dcb82f2547c6afbf9c84cf3529cc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "377fa3b6cd3d4ec1d474592969e3597e3dc216ecd1152d6d4bcf3fcdd8c25db1"
    sha256 cellar: :any_skip_relocation, sonoma:        "578d69b9d161431ab116310231cc67d468c2e2926a8f2b93530647a797070cea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efa81b38e25db9d6a96122fc20e2f92ee6e5330fea75397b72c9780b117c2a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dcb359196033e637aafe4cedcdf69237e76307ba651ce1a8fe449c468ec5b40"
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

    generate_completions_from_executable(bin/"canary", shell_parameter_format: :cobra)
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
