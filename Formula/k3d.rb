class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/rancher/k3d.git",
    tag:      "v5.1.0",
    revision: "5a48613165554f87e1127d71feb387cbab1c9472"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f0ee4976710a596e375cd907b919474459f363bad04a5d3571ff9cb60f44807"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79e3c5b1c9c8235bccd3184db895f50415afba658e83054abd7c0b944ed4d35f"
    sha256 cellar: :any_skip_relocation, monterey:       "1bf1bdfb70581f214c83a2b58cfd910306ff09c2abaa8932663db5a38d4e3a9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd04b6ab0a83810620777491761c527b6fd015ea9b5655e4286daef772a7d4f4"
    sha256 cellar: :any_skip_relocation, catalina:       "846c7b3c1e50f8a04228f08fcd63e1c2b3391be89b6b2fcb9e913186d6f1f03f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52c39a8864b8a06ff6ce8a8074ccf8449ad7fb7b22c0589844c2458b510d2d86"
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
           *std_go_args(ldflags: ldflags.join(" "))

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
