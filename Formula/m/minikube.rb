class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.38.1",
      revision: "c93a4cb9311efc66b90d33ea03f75f2c4120e9b0"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c31e8d9b87939095f0417654c408364fee92953905447c1128ee6c5d70c72a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80690c46408b61a2073e533325cf16cdaf4777c66eec5c2e3a87b983615d1e1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "430e398f58a5cd08a7f65143fb05a847a8d53304cea571818ed25b0d5ce716df"
    sha256 cellar: :any_skip_relocation, sonoma:        "97505b2bc08deed55885c7ca457f3f3b1150663818bd607a0927968eee778729"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ad4573edd8932cd1f1cdd9f82b360f97124ff63fdf161ac9a145b0444285def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f82f02f15af2c9b7931dd0c240bb5ac63d40276325ed53c1bcfe5c4aff72efe"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "make"
    bin.install "out/minikube"

    generate_completions_from_executable(bin/"minikube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/minikube version")
    assert_match "version: v#{version}", output

    (testpath/".minikube/config/config.json").write <<~JSON
      {
        "vm-driver": "virtualbox"
      }
    JSON
    output = shell_output("#{bin}/minikube config view")
    assert_match "vm-driver: virtualbox", output
  end
end
