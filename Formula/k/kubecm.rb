class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "5ac6928cf87092a9ef6c5b620065b4da0fe981c716566e0aaa9959f007294362"
  license "Apache-2.0"
  head "https://github.com/sunny0826/kubecm.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58bbfefd4f4690223bf8d9db1487904a6a3375ae4ea38ea3545bddeaa6f73b0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58bbfefd4f4690223bf8d9db1487904a6a3375ae4ea38ea3545bddeaa6f73b0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58bbfefd4f4690223bf8d9db1487904a6a3375ae4ea38ea3545bddeaa6f73b0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fa53bb01c1b646eca50397b1c85d747dbfc298bd01588806f5dc1d6375e514e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ca5bf3f0bf2d59221a93d7214fc0fc49c1487a08c101b12a434f886271cc034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "892a724104214e188c3b8459505d9078cd8c80d8ffc22895497f17fa83ad621f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubecm", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
