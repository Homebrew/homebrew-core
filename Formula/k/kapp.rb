class Kapp < Formula
  desc "CLI tool for Kubernetes users to group and manage bulk resources"
  homepage "https://carvel.dev/kapp/"
  url "https://github.com/carvel-dev/kapp/archive/refs/tags/v0.64.1.tar.gz"
  sha256 "32f79f2e25a8b67e2f8456e1446acaa8bd9a6593680a1afadd33179a87f95d67"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kapp.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ff0deb34460ced94c830822c2afeec04d2f02be064c44cd317f9b1024a3bb7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ff0deb34460ced94c830822c2afeec04d2f02be064c44cd317f9b1024a3bb7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ff0deb34460ced94c830822c2afeec04d2f02be064c44cd317f9b1024a3bb7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "42dc350969ed21ec5b85cdc93dac10a05b52a8181237260cfb20e0a6f38b9836"
    sha256 cellar: :any_skip_relocation, ventura:       "42dc350969ed21ec5b85cdc93dac10a05b52a8181237260cfb20e0a6f38b9836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cdfdd87b0b11d42bd1e2a77d01e6b054254c89b1d5b412a0e698788f8024757"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X carvel.dev/kapp/pkg/kapp/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kapp"

    generate_completions_from_executable(bin/"kapp", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kapp version")

    output = shell_output("#{bin}/kapp list 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    output = shell_output("#{bin}/kapp deploy-config")
    assert_match "Copy over all metadata (with resourceVersion, etc.)", output
  end
end
