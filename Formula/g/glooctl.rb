class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.18",
      revision: "2614e4b19a6456a3e4435543dd3a2d2f88639aaf"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8ce90236b5e128905e6e87eeadb7af17676f089949bd63920bcc8428a5c9c38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec9b4f4907e741aa46652d9d053773ee8817720b1e32c97f8799b518133bb933"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dd99019f82e155271303b38c71c1122b23bd321d8f45dc73e5e8cf5acd57e18"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b1ec61149f07ebc221c1d71c1ed789ffeb94129675d2f585cea6c470a6ef181"
    sha256 cellar: :any_skip_relocation, ventura:        "3fab56697e5b7d16bd47f6b3c5be1d22a7fb8dd3b051ebc390732e232f4c9c5e"
    sha256 cellar: :any_skip_relocation, monterey:       "f249b798fb7f2ed2d83a42c0a7be2feae10464d76574617d258e279585424192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce62fe293e93ee052047d8aa851a8f3821dbf0d42f517c7ec0ddc6549bb1ab2f"
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
