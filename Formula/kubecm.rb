class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.20.0.tar.gz"
  sha256 "e6d99e61df5cf787249a6b57c844404c4b6733c08be2f0f2e4f9d36a174ce272"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c01bbda06bbc77cc419b06cd5f34d775eeb3a760c17a6b03aa079b0ef6ef1f82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d6b89bf0c40835d79b395e615771268e33419c9105b4b51caefacf292fe17b9"
    sha256 cellar: :any_skip_relocation, monterey:       "ed4b0da885859af43f70cf9d58e2dadfcf9ce852c2edef4399112c93db09eda5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d15f05825490628ee143a7d58240206f08afde16cb739d67e7f2e2f23bc6c59f"
    sha256 cellar: :any_skip_relocation, catalina:       "fb52e49363052f999eed651adc3530dea5b0bd869c3bab418978c657c1fd3a29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91ff06d283462a95364baca954abe8880830fc95f5b7caec84a06239d58958ab"
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
