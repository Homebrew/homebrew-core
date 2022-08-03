class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d.git",
    tag:      "v5.4.4",
    revision: "85841a1b1640cf3548372d2e4730c564365f6bac"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "139a6b5277d77952b09929315d3f472c2c33e4dc518d5918beadde942fdd8113"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83cc1714cf322e5ddeebb1ffc174e0092bc34e7ad9f1aa9d68071bafc052ecdc"
    sha256 cellar: :any_skip_relocation, monterey:       "7836a1a39c8f6c2b38be93db8e6f4ed9018b9ac5d3a03db9ff4b5461dcce1ce7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8835b95d0a1391b9ac7d1ca6e4b1d312c0fb45daa462b14633d7e024bb67526"
    sha256 cellar: :any_skip_relocation, catalina:       "dbfacc13154ca2bcdb7530e35875591bee7f6955eeced9f52bb6362d4a82f82b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61a22fa1f5be965e2fdff4f40b9617f10dd00f57ebd1a20d45f581aab977f269"
  end

  # Required latest https://pkg.go.dev/go4.org/unsafe/assume-no-moving-gc
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

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
