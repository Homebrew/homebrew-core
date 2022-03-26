class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d.git",
    tag:      "v5.4.0",
    revision: "ed3aede715217883ad2fb521ad41467207d97c14"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41c2469e48c8cb188e5d7dcca428ecc55d18f83527fe7b6bc5bbd231672eb028"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db93a045dc43b8d61395f1ca33ca5b6f77fca14e44a30ffbdedaee0a472fce3b"
    sha256 cellar: :any_skip_relocation, monterey:       "ae559b2904237997e1ec299c937a3bbca3c5e707e11a733066d372c3e4fd4ea8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f60292be2dc2460df8771178b8e4eaf9ec5fb7cfa3bf0cafc256c1670d208a3f"
    sha256 cellar: :any_skip_relocation, catalina:       "4d882ecfc0f37019ada4752ca32eec26f5594b275fd8a5c26a77a79c0ce835cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9526672cddacd5ee8aaa6b294036da4cfdb03e87e642cda8c1cee61463be1a5c"
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
