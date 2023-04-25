class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.13.14",
      revision: "a40c7d7db03bba3d4fec73eddf2de106195d675c"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "895cf577f5fcdf4e2c1f3f216bbf6d4899117adaeb33858d4938d9af9231e881"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dd88d572124b5beba4b6c68afb8cc9597601458a330be310de0208d5892d376"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfb36254afc7c51bd3a6238707ddebf823e56fb39361b861c3a5c40037a98a69"
    sha256 cellar: :any_skip_relocation, ventura:        "f4190e5c2ec83313968372253c193045a104a9ca9eab561718585bdb22bc22cf"
    sha256 cellar: :any_skip_relocation, monterey:       "96956ac7a5f84954ff8f1ab6f1b3c6186d1c115098c6ad435f6a93ee9224b712"
    sha256 cellar: :any_skip_relocation, big_sur:        "347b981f707be3c8c7d7b4dc7c00e9098101e65b4587a2206635e1deb03f974a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74c0309d61e193797d07d9683ba9a49b9751b11fd75e030ec4bb242ad2688371"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
