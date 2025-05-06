class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.18.17",
      revision: "589dd14a2194fa096c6d4a2cba01ad33573dc36a"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "706e9a4c0f18af14e7834de7bf864e8ec49b3f53d3bedb1f5ee2189a6c07ac28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b25837f0cafca00cee1d228820ff51ffe072405b8cc67f961bf4618d2526d76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8f3faccc466d5a8bbcadc421c9ed81f608a82a42599079202c1d923a8e5571d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4479a9d2810e3bb368e32e1b7a142e82240d2e4d7b05bde2607bed19b4b3b2b"
    sha256 cellar: :any_skip_relocation, ventura:       "5f1235ac99127a597619cfe066442de65360763c231533277a340510cdb27cad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5695b292a32dc63404775e030ccdbd97360698ecea8c11387c4ff59dff54ccd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9487e0c696da41ad7201af51b2ab39060ef9775de9984b7bf2bf902613884988"
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
    assert_match "\"client\": {\n    \"version\": \"#{version}\"\n  }\n}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
