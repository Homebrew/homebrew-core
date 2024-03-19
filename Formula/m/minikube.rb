class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.32.0",
      revision: "8220a6eb95f0a4d75f7f2d7b14cef975f050512d"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fa25ebc8759ff50e97f915601eeceb9f02dca260b51f9e858bdb1347b656861"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a068a5f5bd364df8e8c0b7084332800943084802c57c72560ae1d7499b8838b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2ad2baca95b4267bc3eec3555dd3228337ce37f892adaba37df845a8ccc6499"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a391ddf8cbc68f14cc70441db46ed7a94412475ffdf16c6a72cea353681ed80"
    sha256 cellar: :any_skip_relocation, ventura:        "8dd2f235c3886a9a3714436202fdb1638ed32b108bb7ca095357d22f5d298dbf"
    sha256 cellar: :any_skip_relocation, monterey:       "6e79f66ab867efbd36a805d92198e1f0843f3be147b94bbc0146d235753c601b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc42a6ecd1d3129b76afe2959d5a126eb4aafa34a34815483e85eb001adc1894"
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
