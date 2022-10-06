class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.29",
      revision: "4755de01751fc76bad75c4336c2f2a9fb74e8a20"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01131bd7e33d4f9ce22aa5c0d3c54d02e375cb73b6bb42496bfbb3c07b8c3f70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f009d628f41debb357c237cb64ea88997ad64b3bb67404494a1267d79781ea8"
    sha256 cellar: :any_skip_relocation, monterey:       "b64ae74e96e7e55540db654161ae35689a325016fd48c78c5a6f97419ab5513b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a86cc6ab24b0291752fbc474003a1a7ac2b6e8ef7ed399d803b58b127d633429"
    sha256 cellar: :any_skip_relocation, catalina:       "f4d59f9c0bbcdb467623fc83a88d85bc79841ffaf3a4e81786cf952561d594ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6463284daf1d6ca317e7976c7748893937341fc5b71dd0f85d40ab22c975e16c"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=v#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"v#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
