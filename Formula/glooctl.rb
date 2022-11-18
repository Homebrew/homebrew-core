class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.35",
      revision: "67640c6f0514a2379143f7337f086a31c7985fef"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eeaac05dbc05bd65d90cc01e606f190839f3d5d07d792c0d61884a5cb521637"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c4d49fea6430291fa94cc45f2a81646d6a32a92feef5960d8d197dd6a006395"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddff9ecdb73fe37fc70d54a23feeba89dcf3c12d53f9dc3e27fdf64acf1d2f07"
    sha256 cellar: :any_skip_relocation, monterey:       "e516b2a18bc0be1744b49bf0a5aa8f6281ecd5970d9f86180951fde2c683ed9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac51f8d1cbb2059a3bae155a3a99f7a3ef76582d072eaca4a4410616dc17c2a0"
    sha256 cellar: :any_skip_relocation, catalina:       "818e89759fb96920935985953a5798b6ce186e0fd41c392edf2e2247ddfb434a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12ab9d5b594d347be39bef8bd2260e96e42891f94f31ecbdba893d76daea8d7b"
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
