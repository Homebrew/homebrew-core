class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.2",
      revision: "a225ba01b9fc985c917db637630ebe6d4b37e349"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "772a79d60b490598ae4694dd081642fc6b295d3c33aa25fb484799e7eb394d85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccbcf4423a3501a520e0c5f9c089ae00a13bc23e5835e7b7ef6a34bc0e7ea609"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bd85a7f01bf7f7bf0aa9eb67f1bc59c681e78d8e7b6f4d1bc8cd620fde927fb"
    sha256 cellar: :any_skip_relocation, ventura:        "36a0a9691780fbe81cea3a915108046df107c87387a8ebae7e3ebc740151fd64"
    sha256 cellar: :any_skip_relocation, monterey:       "ad1eb52b532952cae3e8c153f74fcf4d4f9a9ac86ab9dbffe7b3039556b2e0de"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5b969958a9f878a3b9fd5536095d0a14d95b842735f518ca9a17517dfb06bd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc5e40123b46db8a10c9aba22203f7ea0c88441e85b8ac26273d1ae15e77a78b"
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
