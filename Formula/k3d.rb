class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d.git",
    tag:      "v5.4.3",
    revision: "7e4b1124c891e2b4944f26238ed4938c5404e137"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c2af98a480e0cbc308317d9a690a2e4d7a1ca765e5f587ead80222c1333fc01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68a26f812194dfa53322c7a3f2337e67c4d1fa5d138904ffcdfaa3586da0b3cc"
    sha256 cellar: :any_skip_relocation, monterey:       "5626984ea69bd457991049e606afde54b4d25d20ac2983d02141424f64fe59bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "798fd84e244051fd514ea6cb39b0d2ebe63a665f915e3fdfcb8e7de7b71244ab"
    sha256 cellar: :any_skip_relocation, catalina:       "13cec3c20dc35246e7fd52978d61a2c3ad70f1b5440f25482812ee01446db742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e34f528c2e28374eb3b5a43fec747a8e50b93974bf2a25cc1444c57d985cc77c"
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
