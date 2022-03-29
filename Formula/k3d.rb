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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "821bf66fe4c4e95450baf6cd00ff5304726ad6a51ec5856c5d1929db606d417d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd5bf51b6436f675a24c09a8df0a5beb9c36712859516bcee2ea68783f3b058d"
    sha256 cellar: :any_skip_relocation, monterey:       "eb3cd85fe6ec1f6c4fd07d2b3bb52803e39aa92d9d0bfa8f84fd4e9f5d9b24ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "ada3d7297cbf561e86b6b32ed7956d47b44d0278a190616a45389e3ccdf9bca7"
    sha256 cellar: :any_skip_relocation, catalina:       "a257c3b987d01e39bf4d4ee61faf2295339c0a680d58ab4368a15b8e898b4414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53fcb955ff92d47258c1855bdd4c5d90bfc0e76a6e170a5630f52a7eb1347b7f"
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
