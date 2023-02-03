class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d.git",
    tag:      "v5.4.7",
    revision: "05d839b2b880cd0c764f0794fe0aa029f1300d19"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c336784e94c795ca14f2c386f3c29d820bcfe0cf039b1d5d4f9cb1aaf76a23d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8d2dfd67037402cc11a7bbc869704b9fd4a0f3b1beb90b241bdf0320f0eb80f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "294e9615047ad90d758d700b75a8688f2c435b94bf872f89b40e0fd89a4e545c"
    sha256 cellar: :any_skip_relocation, ventura:        "b6aaa5e7ce3f6ec0093878439ecf6160c3987414b2c897929eb34d9ceaed578e"
    sha256 cellar: :any_skip_relocation, monterey:       "7e5febf2cf5790f4a873cd42db315dc565b9069669f14a3c63d4e71f675fed9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "44ab04cf2b8c26ff02114018fba171be323e75f91cc88b2615309fc82f7df85c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b54a5483a88662242d44450a2d0a22e200ad22543bf2d3e8e5818e1b40715b20"
  end

  # upstream issue, https://github.com/k3d-io/k3d/issues/1207
  depends_on "go@1.19" => :build

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
