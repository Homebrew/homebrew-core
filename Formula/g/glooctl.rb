class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.6",
      revision: "a4b18b9403cb8d81e6486c4cce94cdbff76ac25c"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70f835f6270e803f37a392b634ecd7acebf6275b7f455e634a946cc71a670b23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e595799853ed1db877594f2792566af919b3372df6225be8a89ea7bba2920f12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f592eecff8c87443d057ad05c74ee2df97f0a4692a7d1c1cd77e5c3560c17631"
    sha256 cellar: :any_skip_relocation, ventura:        "0b9775e4fe4e6ab15dc27272ed6c2be78f815dd8777ff6925a666600aa740eb8"
    sha256 cellar: :any_skip_relocation, monterey:       "02e87a33a648c465a0779340d913ebf249955abd1f65dfd6513636c497a300aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "31ef2d33516b1abedb7f5d2e7796ee4dee51d7cfebf383e7da210e7793c66134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c655f495adbf5180434e3ee8c3144878d806780f3b44bc392014674423d691e"
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
