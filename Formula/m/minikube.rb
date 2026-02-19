class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.38.0",
      revision: "de81223c61ab1bd97dcfcfa6d9d5c59e5da4a0cf"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92d441f6491daac5761c50d5c16202deaeec9622bc630a02454893b428dcb7e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec1eb2866c553bbd65a9cf715fd156a1679fe898c3ff3c09f1aa4e85b870c927"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "317d24b6508ebddee5a28470dcdb1d403d8e09187d52dfa8889538a2a8435656"
    sha256 cellar: :any_skip_relocation, sonoma:        "f79b5dd4b72b898e04656737ffbef7a22bd909836eca720339728442f5a30fc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b0b0268968c6aa57aecdb05712100f9c57e72539c890f90fd605b10f3ae4843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fffb842b2427a7fb35ae4b3ba5719aba1dbbc92db41579f906f8458c2d89141"
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
