class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.34.0",
      revision: "210b148df93a80eb872ecbeb7e35281b3c582c61"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "aa24c68a1d5b907339034f70b2562f798f1a24df5e205170ba8261e27f984366"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "285f8ef7323033de62862d0ba5ce50b26e6f87f2d77dc049edc3c4edbe1b5d07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5108148670b6cc65390d9e16ebb43b94fa5ee4e42174a7c53a1aa277cf44f77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f783225ba09fd092e225679524908b5b9784d3335880c27b668127561d8faae"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a985c47ef76fc8757056863346a72f9424257a6bbb77ab34a0b4d457a8bdf9e"
    sha256 cellar: :any_skip_relocation, ventura:        "cfb30d1540c224044136bd4c15004df6215578221bb0dce6bc129c889798ae95"
    sha256 cellar: :any_skip_relocation, monterey:       "f98112f8bd1d923ee2b48444ed89126d9009778c228f05384b0ff5659b282e56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9405388577688d423f948afa70bc7a32a6e687c3ae71a95b1c373f9a625417c5"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    generate_completions_from_executable(bin/"minikube", "completion")
  end

  test do
    output = shell_output("#{bin}/minikube version")
    assert_match "version: v#{version}", output

    (testpath/".minikube/config/config.json").write <<~EOS
      {
        "vm-driver": "virtualbox"
      }
    EOS
    output = shell_output("#{bin}/minikube config view")
    assert_match "vm-driver: virtualbox", output
  end
end
