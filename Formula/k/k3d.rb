class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d/archive/refs/tags/v5.8.1.tar.gz"
  sha256 "b4835360685b89ce1e13e1ccaa3f4d0cd7775b09c7ebe6dfc9b0e3d64f952487"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f84fb5b90d26a4df00624c9db1444aa910c7b086030b8e2ac6def5c54bc4ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0f84fb5b90d26a4df00624c9db1444aa910c7b086030b8e2ac6def5c54bc4ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0f84fb5b90d26a4df00624c9db1444aa910c7b086030b8e2ac6def5c54bc4ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "40e775dd6859febfdff60b3b6afbbabe3528d7585874ba939bb56fcc33c5e600"
    sha256 cellar: :any_skip_relocation, ventura:       "40e775dd6859febfdff60b3b6afbbabe3528d7585874ba939bb56fcc33c5e600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db1ea3f973ce4c8374e36b7fe2ff608d8122ffa80d3a34354704ad82c0abfed7"
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
