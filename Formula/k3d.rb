class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d.git",
    tag:      "v5.4.6",
    revision: "f6838597ddf1cab5bcdb391f883748c6e4d69b48"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f293de10b116362824344147adfcff5ce2b7f37adba389ae103dc98f1cb6a960"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c608cdfac7d77fa478899ca9e2124d81ac3989b3e2dcbafad16c86b72eca2d0"
    sha256 cellar: :any_skip_relocation, monterey:       "5bdd4c7a09e50e72c0100900e08c764d0ce1b138b4a9526b14d2b33405aa28d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e45918e27498687d60a78d5bf6a16780686f5c2cfb4d7dd8cabb8eafb31839e"
    sha256 cellar: :any_skip_relocation, catalina:       "29305ebebce62ce51c22e0bddff854bfba2e24e8b895f1cca06f3a921caddf6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba76378b208f4fb00c0f37287b3de9543c2a9c9f70df92c68e558d6e1b118bc5"
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
