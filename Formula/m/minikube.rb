class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.33.0",
      revision: "86fc9d54fca63f295d8737c8eacdbb7987e89c67"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a21da6d7d01f1f8a33857ac0bebb75eade7386e0f54f9f5dd3438220320f61f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34b2325e87a17cf3ac3988bbce202b54e0c615fdb9652fd87b8f7ed8a3de3ab5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89a5056cc3b238455ae12efed0ad66e26d3ee1f4785d23c0e958c96da1291c08"
    sha256 cellar: :any_skip_relocation, sonoma:         "94a75755847ce76e9212b5523247030a637d96395da6d3bbd821cfbd8f3dc2fe"
    sha256 cellar: :any_skip_relocation, ventura:        "fa65e4dc0c9a3884097c8da849ccb1eb12971eda6302860ebe2342dbcee25670"
    sha256 cellar: :any_skip_relocation, monterey:       "1538e68129e6c93a138ec187e091c2250662727ddfba77fc203f1671abf31497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc6b79900f814c7802c030bebbea0f0773b417f6715375b82c947cf3d7a5f8c5"
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
