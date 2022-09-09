class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.6.2.tar.gz"
  sha256 "c73377dfabca4fb3dcf5ccd28970f8fc1ece771a5c03f33fc05738b55ed59610"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6275a9d0c416d51c7d7f6c1dcbcf02540ab75b6dadbec28d16ae5f6192e14ecd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3733866c1255d888a53f9419fe14c098e85a1c7c3c5566417db85307ae35752f"
    sha256 cellar: :any_skip_relocation, monterey:       "c128cb7102a26d0db47de9f123238cca3fa0f2acd5c0aafa6f175c5d50ce3d0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbca381249752a09db88f168213110715b50f0ddd9954bc910fd5e74bae1ab43"
    sha256 cellar: :any_skip_relocation, catalina:       "27d55e0da94b58a9fc3176effc9490b7e5edfeb5608f40fbeee33a6d2d821887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84b9af6dd8a61755b7cbd5c11d626c6d975069ffd20b7e2e66d83797313dac7c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kyma", "completion", base_name: "kyma")
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
