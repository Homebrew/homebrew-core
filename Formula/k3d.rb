class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d.git",
    tag:      "v5.4.1",
    revision: "7b8c0f483ff124f217d14852ca4e937701e9003e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfa9215a5bfa3f132c8536417b9726c82086609c16d15be69d4daeca15ab7b07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e94471752c86ea851cf973ebde97c62fb44b3bcf1c275847d8b85bc8829c5a2e"
    sha256 cellar: :any_skip_relocation, monterey:       "cca152ae34bf2cbd6a903037b7122be12a53971b37e9c64e0981587cabcc4a25"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf35e385b5152299e8e181ae5f215a64c769ea55cbb48d563cb8cff64d52f45f"
    sha256 cellar: :any_skip_relocation, catalina:       "82fbba63a88fdeda2ebb334751cc0b2ce00b3069e660147aa4cfa3d01fd9604b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "478b3f2e98726a9af09d9f84b55a0f927f1e9cddbe7d74d02a952716a90edc24"
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

    system "go", "build",
           "-mod", "vendor",
           *std_go_args(ldflags: ldflags)

    # Install bash completion
    output = Utils.safe_popen_read(bin/"k3d", "completion", "bash")
    (bash_completion/"k3d").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"k3d", "completion", "zsh")
    (zsh_completion/"_k3d").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"k3d", "completion", "fish")
    (fish_completion/"k3d.fish").write output
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
