class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.12.12.tar.gz"
  sha256 "1914686ff67bc852948a58fb95d6c438c824ce3a4d02f9b501b4a8770991bdb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ff07a9a057af7ec6d483e10f0b0ae26188147f217d536584f37d5e8bb0ec4e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13af02b7738a43646c8b53ebca4f29c6c6478bbd60403c93cb5853fc684563ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02f52c21e8544340ed5cf3fb996b917b6fd9bf51852aad46a88dc011f1d3fed2"
    sha256 cellar: :any_skip_relocation, ventura:        "be6912615074a07ccc2d73a89c5ea13f0641462ced17404f4bb6a1935106bc2f"
    sha256 cellar: :any_skip_relocation, monterey:       "0773f32a3da8b3a316d1fe8fe12f28205b262c4b9472ce3673b8bdc6184794d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "2937a2a1000ceb333363409054fb47f51154ed81a836c45d4bd7be8a31c58f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "366beb6cf5bc950598bed49c88040cfef978a21adabfb7ddeb5d244cb6a4fd61"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
