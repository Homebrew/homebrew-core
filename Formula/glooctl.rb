class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.6.1",
      revision: "01df0eed28a66f01bc212dea26f920220ecfc739"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a73f40bc024c7a9727892545b6cfcf7ec831a50b865c7bbe720ef64a4ac1a6d" => :big_sur
    sha256 "b00ee95384e2cc3851e6a1d3c2f4746ca9a8495b9b6f8ce68a3fa3d90c4726b2" => :arm64_big_sur
    sha256 "df7ba698bcde19b623ad5cc04cd6250868bd9162f3e243e8c1bacf457c9b28ca" => :catalina
    sha256 "1490b535742222c67ae91abdaa31712b19c6ae0d80abea98c002c8b0fb9ed987" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "TAGGED_VERSION=v#{version}"
    bin.install "_output/glooctl"
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
