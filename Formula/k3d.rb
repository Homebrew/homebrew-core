class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/rancher/k3d.git",
    tag:      "v5.3.0",
    revision: "bb8a2b0bb57ad69680e4e2a0772a0bf31f35a457"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dfc266b1c1cd74e9b7966c64ddfdf95e9fa6a176ad2b6a58e34a17fec508265"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94ab53847ee937274e0141112854aa0d4c48d8e17c8f1f164a19db87fe00453b"
    sha256 cellar: :any_skip_relocation, monterey:       "0496fc879f0295747b92973e5f121245fa5b1ac8f9e784a4fd9d43e3b78d8a6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bc6f5f71bca1616ebb8b1ba95ccd146f71bfc064f5d3732ac56155a989246cb"
    sha256 cellar: :any_skip_relocation, catalina:       "37f98a449a10e6e999600119d232ef150664740eaae3a5b691aaaeece7bebc29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eae51434c99ffd5bd21d595d89f490a06064dd1e51f29f45f2f068cd5b0d764"
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
      -X github.com/rancher/k3d/v#{version.major}/version.Version=v#{version}
      -X github.com/rancher/k3d/v#{version.major}/version.K3sVersion=#{k3s_version}
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
