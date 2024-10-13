class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d/archive/refs/tags/v5.7.4.tar.gz"
  sha256 "419e1bc3a44d57f66512dc2be3cae118482db65ceeb7baba41a6df7ea4300263"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0428245f1434d4933274c05c543b7880fc95acd62bef43e23662bd844d0e4e4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0428245f1434d4933274c05c543b7880fc95acd62bef43e23662bd844d0e4e4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0428245f1434d4933274c05c543b7880fc95acd62bef43e23662bd844d0e4e4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0428245f1434d4933274c05c543b7880fc95acd62bef43e23662bd844d0e4e4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5016f1b09646e1ee720f2fc2155eabac033f778c7bcb98fb3ad2d772cb39a9e8"
    sha256 cellar: :any_skip_relocation, ventura:        "5016f1b09646e1ee720f2fc2155eabac033f778c7bcb98fb3ad2d772cb39a9e8"
    sha256 cellar: :any_skip_relocation, monterey:       "5016f1b09646e1ee720f2fc2155eabac033f778c7bcb98fb3ad2d772cb39a9e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "131c2b406a323e70d54ab687d6126bfb5b4c87cdf16145416aa9458442d46d65"
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
