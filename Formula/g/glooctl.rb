class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.16.4",
      revision: "fb412e06e38aaf85ae206f06e180e08a7ad56b00"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2272552dfb7d5658640e2ba319e79c2a8a3793fc1969a1ed91846d0c607708e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "471e518d471c0aeb81ea5b3e23ebeb9537bfd1b2b5920ec94cdfc58d17c4256a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2fd9bdce6852d429926de9eb547cf4bcd4ab1756391589bd949ccfda4b23dfb"
    sha256 cellar: :any_skip_relocation, sonoma:         "de6f2af2dfc89aae6fe6251a4af68bb7b4aca613eb1779da687f814349a9bef3"
    sha256 cellar: :any_skip_relocation, ventura:        "04ed0deb7c080ecbc4246034dc449709704fe1a525f3e0dbb5f282eb624aaaa8"
    sha256 cellar: :any_skip_relocation, monterey:       "f4b4c6f980adbcaa2d1074c969215a5ec48081a55487ff3f0e7ec0dc154b7749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6840fb506991002b3f9c3c8afcb3a197390d77f64b0d7e936f1d03202b4a7aa"
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
