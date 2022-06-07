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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a1ec14f5fa489c1eb78be015b7d4d33ded5b8581739ebe55e624084f82bcb50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbc029b84faa5add64ebed7466479fcb9a9338ee7a45022f6f9054ef33f26b4f"
    sha256 cellar: :any_skip_relocation, monterey:       "4e09b565da40af8db08d0bda65adc255472a54aeb903d063b3bb2007e30ac415"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f957b3942d655a25627b2dcbfc3e430691d9e892fc40e4e8dd25a03a63f3750"
    sha256 cellar: :any_skip_relocation, catalina:       "da055fa9120ff5d846c05a86522383d26d515142569ff090361e0076eb3e809d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f56597226f3c8f7effcaf912264b5318c3fe0f00e11be31ee34f5faefe729ca2"
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
