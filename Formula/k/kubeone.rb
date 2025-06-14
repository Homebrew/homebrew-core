class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "844fb53c2b5a312b918234639230a9f8d4b6a1d5e623962ed5582eeea52d27ca"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73fa578be67ce154828226aaf4846bc86d8cc5fa259b58a088aebc89a01792c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b471cddc40c8871a259d58be2eabeff40649d1d0ae748d297397400eefdebc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c72faf8b39531f3136b8fe2530161a006413f78d4c33f3fc59596ba3709eb557"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cf6d2f4bfa753f76e4a8bbdd6ed4bf9c5d8495b41a9c0ad63e1c54653a6a4cf"
    sha256 cellar: :any_skip_relocation, ventura:       "22dfcac2561277a23a8b2c2ad9b1cb6dde060a17c094b93232fa5c4bf25bbf50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7865441f2950c0b04fdbb3b004d9af2a9fbb08cd6ed272959b9942c0df51dc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6397c4cdf96eddbd6f43e88ffb50d7fbefd7a5ac85b1c77a067ca611a634ccc6"
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
