class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.13.7",
      revision: "ab4b67b24b93b068172930c010ad8b73b4acc7cc"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5238075a3b161b84f84451dfb0eaff19f43a6c8d2145d4cba989328a3cc67621"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60790e3f14bfe774a4dcdd8bfc75c52f255693091a1d909cff20eb8dca38be32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75dcd8e9c54b61b66850088ff660793a70a49db81f9ba3734d5f5e56fd6a65b1"
    sha256 cellar: :any_skip_relocation, ventura:        "b79d038c71f61057487a938511c55a178a7bf3a386019b2bed3d97e528464bf9"
    sha256 cellar: :any_skip_relocation, monterey:       "ef656d8784400bd6c8d42a3e6c61f59017e96a2d3fd113bf90e4b4143c4ae80f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7234581534f665b50d9bb2b6a53288651c2c7abed44c9d3c739476695e6ef5dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e1b6be1369096943b679a0284addcbe4aa502ffda9d0d3fb39b517cc3d46b83"
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
