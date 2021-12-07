class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/rancher/k3d.git",
    tag:      "v5.2.1",
    revision: "d243bc9dc1465e15af49e8c1fff61fe171a9aba6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ee6942f80b2ecd9fbf4309ad8236723e0e516bbb7168d9dc962c65e69441580"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dc99402a1c2fec8900d8178d9554d9be86e66f343535c47e681c866af63c1a5"
    sha256 cellar: :any_skip_relocation, monterey:       "1b3eb3facc73a85bec8594ea731d9c208179f6e62ecc5c239aa43345a48cadb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "337f797f3d2dd70287722488c772e73742aa2ee2d15bec4ee4d6ad7c5a042ef4"
    sha256 cellar: :any_skip_relocation, catalina:       "261d07c7803b4c5af2903d80ce030175880954a8b87659b3aaeeaebf1605fc65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6db5631a490b52e64bf7449c80fb3c264305be0a24666ec9990c02713a1b2e7d"
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
