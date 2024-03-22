class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "aeeb81c979ad2134746f8affbb377fd0fef1f62ebe70ace931fbde1a844b540b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5222e19430b9ec819f9c0ee8d436b926f7f31596b4a5a13079ed869add3d639d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2ec194c4f3eda5772223877f1b8b2dfd3b3d3812352114ba496e40287afe097"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cb10d055bbd10ccf8928fc6b7a87c092f9ff23d2c58d78e467a0694eed4185e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fc26ddcbc00b2586955fd42959e52a8dcbcaa4c333009aaa3dcc8da310ecb36"
    sha256 cellar: :any_skip_relocation, ventura:        "d1dc159e999da85bb11690261ee7a8202c7b0f8b686e3c36ec2095e58ab38fe3"
    sha256 cellar: :any_skip_relocation, monterey:       "fe9f741ebdc364b5fc1b4589a43bcc79d8706677f9d5e7e2cbd597d5da29dfda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f516787aa3fb70f0b5f47c7984e887917d3029d242f12cc49703dc0886e04f53"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
