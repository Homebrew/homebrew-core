class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.39.0",
      revision: "7a9f6a841470a207de8cf4bafcccee0969d8ba10"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17e0fe7f9500e3b8704ae70b8e5c1c9603c4ac431c2d69fbb0e1c325511c0692"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a4313593f7dca6cb8f16cc8791ce053d84742d4a075d3c7646f794b39efd55c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b1dc08bbfd0b90a9ea6646d239ea3247340f32291cc7a6d5f319360afc72146"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "01a90891dc2e3c6d57740c222654d20930aeefe9030b7664873fbf74c5b1e767"
    sha256 cellar: :any,                 arm64_linux:       "abd3172ee766e0c802f509d1db773eb1f655993071795a70c6edff1869b3f5fa"
    sha256 cellar: :any,                 x86_64_linux:      "bdcdac9a2eacbc0f5a4a2f6ec34ec12b5c3d588f3bfb8f6dfa4ecc1bd80f57aa"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    # override the Makefile's pinned toolchain to build with brew's `go`
    system "make", "GOTOOLCHAIN=local"
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
