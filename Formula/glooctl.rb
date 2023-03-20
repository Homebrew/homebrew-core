class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.13.11",
      revision: "6ecf80b83e1d1a5e68aa8496f96f8239d473eb77"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b2c00373e6415ded2ea9a3bb11e43e97e15567af08c98063e88f490de299998"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31cd751d34554887e801ecb3bd9930b6de3b61208940b3fe473b8f7f041e1421"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4dd3e20f8092efebde224bae287e8f6ee00085623a97282b76eec0e4e689230"
    sha256 cellar: :any_skip_relocation, ventura:        "a50caf65a494946702bd1528f857966a64b30c4ac884e0939b8855c058da21f0"
    sha256 cellar: :any_skip_relocation, monterey:       "fc854a2472d233818c1a7348bbed7a47323eb5a7278824a9ee3e713ee5a1f300"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c16fd596944cd1e81951ef99ef4657040a5803fb2b43b81d9b069cc8b9a7811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66d7ff1306d95777658f6d58b67046eaf7c1691afd5e98166ec59968b93839ee"
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
