class Kapp < Formula
  desc "CLI tool for Kubernetes users to group and manage bulk resources"
  homepage "https://carvel.dev/kapp/"
  url "https://github.com/carvel-dev/kapp/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "cfe141f6e00816e9bddaa3d32216295176386b42d9202adbb76f48b78fd5e979"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kapp.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5392d1c444411b771ab5651b09c4779004a8a979ef1e4db20ebb9a1010e6716f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5392d1c444411b771ab5651b09c4779004a8a979ef1e4db20ebb9a1010e6716f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5392d1c444411b771ab5651b09c4779004a8a979ef1e4db20ebb9a1010e6716f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a87e16dce4aeff42ab1e88096e35c6a78d3eaa1fcca5076b1a8b7461aed92864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "405507876fe4b05e0420112238c97f7ef22971dca45137139474f09525e7fa15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97526aee57e11d21f2bb509ab8787c5f4f70b7ca58a65f2f7098f9e194769ec9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X carvel.dev/kapp/pkg/kapp/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kapp"

    generate_completions_from_executable(bin/"kapp", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kapp version")

    output = shell_output("#{bin}/kapp list 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    output = shell_output("#{bin}/kapp deploy-config")
    assert_match "Copy over all metadata (with resourceVersion, etc.)", output
  end
end
