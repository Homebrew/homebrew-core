class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.24.1.tar.gz"
  sha256 "8370d44bf1e782a564f1655450a063a30f37d13c5ebdcf7bc6b440d0b346feb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9864609335eebdded6723ed03e70b7e538819e8d1c96ae7825c0ced05bced4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9864609335eebdded6723ed03e70b7e538819e8d1c96ae7825c0ced05bced4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9864609335eebdded6723ed03e70b7e538819e8d1c96ae7825c0ced05bced4f"
    sha256 cellar: :any_skip_relocation, ventura:        "3da3784900a6d68527db6fd0f87a58f9e0891ca6e1e375526bd4e0b94d36ae41"
    sha256 cellar: :any_skip_relocation, monterey:       "3da3784900a6d68527db6fd0f87a58f9e0891ca6e1e375526bd4e0b94d36ae41"
    sha256 cellar: :any_skip_relocation, big_sur:        "3da3784900a6d68527db6fd0f87a58f9e0891ca6e1e375526bd4e0b94d36ae41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f1886ea8dfc26f385f99d35251828a9d69b9807c9f60bb2c888e6319498a5c8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
