class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.7.6",
      revision: "eaf5a074a050776e8e6e4bb3efadc6448f0e9797"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a379258df0eb19a3309d737a3954261b3bc7c62d3ba16e355215e84d14ea6984"
    sha256 cellar: :any_skip_relocation, big_sur:       "3881ae1d54e2bc3d9ac65859e2ac7809452f194fa9c5d1363a5723be925124f3"
    sha256 cellar: :any_skip_relocation, catalina:      "c3ab41bd809eb3a7fb97906a739f00f23615df518d800548310f3656824141a2"
    sha256 cellar: :any_skip_relocation, mojave:        "31091e9e6c41e855936c9ff5556d346053ae421f0dc1ac2adb7f19d6a19012a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8f8b519791832403d760800071fb9325a637a23d68bc47a3f6ecc1da858dfd7"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "./cmd/helmsman"
    pkgshare.install "examples/example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helmsman version")

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output
  end
end
