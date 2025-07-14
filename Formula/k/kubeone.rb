class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "4b72018fa71e86d7a992e59686208c9b23aa31bd6286acb2c2e9228801622803"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "298571fbb295a5c67d001c1b304e05c71f402f76a88a38f156aec9b8ba7fe455"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03a4419cd3540f3b6f698d919e14820e457356177ff86f739c47cf2368ac08f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53767b7de111372582b69df55a472246ef7694ad486779cb57af92d490230738"
    sha256 cellar: :any_skip_relocation, sonoma:        "e759f7013339b6389bd46284e25574a757391add6bdf5a31fbedd2f175014b34"
    sha256 cellar: :any_skip_relocation, ventura:       "3e5a5aabf66f49986f358330a70cbe250498fc31548bb07514787ed4c0445f60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7749a53fcf9b61ab572f0acf02757caea6fa98e008adafc8b2573ce5b5d8358a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f99cb1e8abbe32541ba7f0084f0f0ce1848f623b3ca0cefa82218c54c6d0585"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X k8c.io/kubeone/pkg/cmd.version=#{version}
      -X k8c.io/kubeone/pkg/cmd.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubeone", "completion")
  end

  test do
    test_config = testpath/"kubeone.yaml"

    test_config.write <<~YAML
      apiVersion: kubeone.k8c.io/v1beta2
      kind: KubeOneCluster

      versions:
        kubernetes: 1.30.1
    YAML

    assert_match "apiEndpoint.port must be greater than 0", shell_output("#{bin}/kubeone status 2>&1", 15)

    assert_match version.to_s, shell_output("#{bin}/kubeone version")
  end
end
