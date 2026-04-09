class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "fe6c08075c45ee595c59b7f87e6e226c2ee8a0a237f22f409b55a1b83ffe037b"
  license "Apache-2.0"
  head "https://github.com/sunny0826/kubecm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47b5bf08e4d500aa7f6d5febe44b966222b011e7cd1683a58db6e24e06d6a4fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47b5bf08e4d500aa7f6d5febe44b966222b011e7cd1683a58db6e24e06d6a4fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47b5bf08e4d500aa7f6d5febe44b966222b011e7cd1683a58db6e24e06d6a4fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2a5651ff80b288a302298ac7039762dabae6f8a881067f4c8061a2cff8a03e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc2af32341935ac3b5218a09bbb8388edef3b9b9b66e02482ee1b6ff5f90f537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5713cd188a69e12bc4c3190c2302809357b8b5c04eda7ecf7ab7833ecd5c52c"
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
