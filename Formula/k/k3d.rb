class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d/archive/refs/tags/v5.8.3.tar.gz"
  sha256 "2ef51e029f43e70dcda616de98980017ca7de18848265525bf7882d2bd66f9f2"
  license "MIT"
  head "https://github.com/k3d-io/k3d.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "061ed00413355c51552cd12f0ed027d4ceb710503b3632a6e2f47d657015801f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "061ed00413355c51552cd12f0ed027d4ceb710503b3632a6e2f47d657015801f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "061ed00413355c51552cd12f0ed027d4ceb710503b3632a6e2f47d657015801f"
    sha256 cellar: :any_skip_relocation, sonoma:        "626f581c808ed6b5d5560637a2d47a5214acfee40caf07ec54a7dc2c3695fcf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7f61f211d7beed0e3a590f86881ae37aff69a88bf5cf29c8a7df3718ea473ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ba066d4441eae8a538f73024c93cc4e27ddc224ad24240ea37983d617d37ae5"
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

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k3d", shell_parameter_format: :cobra)
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
