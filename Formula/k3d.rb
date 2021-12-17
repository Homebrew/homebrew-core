class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/rancher/k3d.git",
    tag:      "v5.2.2",
    revision: "0c57cf24ca65fecba4dd24624a27364def22fbca"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e589edef5e808a7e864075e4854616eef1ddb4e5e89b4040ab0ca7f616521da1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7964acb0013fd24967648f63cab9418cef6b5d9b2cb6755d5c9136b19c189768"
    sha256 cellar: :any_skip_relocation, monterey:       "365d4f5ca0c72a5d64b5454143b692d4c5d26e972f554d36bd652b937b4bb463"
    sha256 cellar: :any_skip_relocation, big_sur:        "97885bcced31d559285c76e90cccd40f48159a157818c20f876e5a0710e19452"
    sha256 cellar: :any_skip_relocation, catalina:       "08fbb00112321513ab3dc77ad79023f8fe86c4ca3a7c4ce579e7aee8341bf3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b26007833f38b6556a751301845630f48fc1783c6c58e02f3424a8ae9d9967f9"
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
