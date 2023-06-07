class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d.git",
    tag:      "v5.5.1",
    revision: "1afe36033dc7f28479ce3de1e3c3c3efba772e6e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "235e15d4d73f7d10f94a7bd7447f7707fc6e0f8437d4ae28162d8e8f51f480c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "235e15d4d73f7d10f94a7bd7447f7707fc6e0f8437d4ae28162d8e8f51f480c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "235e15d4d73f7d10f94a7bd7447f7707fc6e0f8437d4ae28162d8e8f51f480c8"
    sha256 cellar: :any_skip_relocation, ventura:        "21b90c5368cce03cad57e27567d4300ca6e24251944c24398edc8b245d29990c"
    sha256 cellar: :any_skip_relocation, monterey:       "21b90c5368cce03cad57e27567d4300ca6e24251944c24398edc8b245d29990c"
    sha256 cellar: :any_skip_relocation, big_sur:        "21b90c5368cce03cad57e27567d4300ca6e24251944c24398edc8b245d29990c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb75f945debbe4e7f89604db670e3c0147c83ec89df6acded63617e1c900b34b"
  end

  depends_on "go" => :build

  def install
    require "net/http"
    uri = URI("https://update.k3s.io/v1-release/channels")
    resp = Net::HTTP.get(uri)
    resp_json = JSON.parse(resp)
    k3s_version = resp_json["data"].find { |channel| channel["id"]=="stable" }["latest"].sub("+", "-")

    ldflags = %W[
      -s -w
      -X github.com/k3d-io/k3d/v#{version.major}/version.Version=v#{version}
      -X github.com/k3d-io/k3d/v#{version.major}/version.K3sVersion=#{k3s_version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k3d", "completion")
  end

  test do
    assert_match "k3d version v#{version}", shell_output("#{bin}/k3d version")
    # Either docker is not present or it is, where the command will fail in the first case.
    # In any case I wouldn't expect a cluster with name 6d6de430dbd8080d690758a4b5d57c86 to be present
    # (which is the md5sum of 'homebrew-failing-test')
    output = shell_output("#{bin}/k3d cluster get 6d6de430dbd8080d690758a4b5d57c86 2>&1", 1).split("\n").pop
    assert_match "No nodes found for given cluster", output
  end
end
