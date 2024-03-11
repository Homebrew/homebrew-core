class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.16.7",
      revision: "fc46ba6af98d169e297d6c95e83c9549e3b853c4"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1aa7ba18fea1f96201e8a304ff729c0b9c31605e2428f4890983563bdfa23e54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f87efc456418968e1ad0dcbe33ef80413b4bd85931e24876f15cf9b3ffad58a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "818d05b111c622eb9135b4f58410fd1fa0a03dbaa63434dbb58296895745cb86"
    sha256 cellar: :any_skip_relocation, sonoma:         "84bfb0bf155b7fcf360d9990aca6175db380560861af80397b31a96c54413353"
    sha256 cellar: :any_skip_relocation, ventura:        "81a148aaed9168daf970dd1674582488c9a362d1dab2b88f0a13f95e44025412"
    sha256 cellar: :any_skip_relocation, monterey:       "73c40d5ec8ffd34d0ec0546c74bf0afaacc3049aadb56e08c9d979a6187a030e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7156946bd9958b269ba900211241a0d4ae3901ac903e69d8f29c3529878acd03"
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
