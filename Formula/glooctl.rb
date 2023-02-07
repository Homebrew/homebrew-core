class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.13.6",
      revision: "34f66f40257871889c9c6a842b938cb365a9ebdc"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9f033554d633dcbd7d2482d6d2e1d705bc4fd632d7e860369ae64a5dbf97b5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4e022f3b5f63241d75775bb785699f0f70c30d15fa9d0d2673d65ec6d280150"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07f5b0c809cdcb96a3ef45915386463d6ffc73dc2f4653d7d1ec02f690fbce9f"
    sha256 cellar: :any_skip_relocation, ventura:        "77e6c1917d2b8a00d7634ef2f2f4bd7378f6316b014b631274169cee2483f79f"
    sha256 cellar: :any_skip_relocation, monterey:       "dff51631be87985f973be75ddfd2fb4d471dea07b4ef98b25f43bfb0530b4850"
    sha256 cellar: :any_skip_relocation, big_sur:        "090b6f92451f61b307f1cf286cba79510a49ebbd326aad84e93f57456b2a0dc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4bbfa5ba415cf0284479a7e049ff54053b7157d592407377d73b0d467e08dfa"
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
