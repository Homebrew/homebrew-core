class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  stable do
    url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.9.1.tar.gz"
    sha256 "bd19d41be2a172b5ad280e29fe7aac6d1f6c8d10c42bc6a4655bc4bb72aab2af"

    # fish completion support patch, upstream pr ref, https://github.com/kubermatic/kubeone/pull/3471
    patch do
      url "https://github.com/kubermatic/kubeone/commit/e43259aaec109a313288928ad3c0569a3dfda68a.patch?full_index=1"
      sha256 "3038576709fc007aece03b382715b1405e3e2b827a094def46f27f699f33e9fd"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15f186802fdf199941c9ea7b9961c5958e68d5be9a2fb6a6eed2898697c71098"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f73f0f99adafc291540f1f7fcd5c89ff3f58eef85e24f6eacf05973af335bde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8c4ac1eb75a0186239525cea6638e133270eaa5252fcc2457895bbc12929354"
    sha256 cellar: :any_skip_relocation, sonoma:        "90a06e7fbee48e812776ecc2d0598028661625b08c7edc9f52204993b7da47f9"
    sha256 cellar: :any_skip_relocation, ventura:       "c29c13f212daf9f00c7ae20527ac837f8fb02e4b2e80a4eca105ad65ebeaada5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9912f3baed4367c173e5a5127f3af63e7f06be05f6118e0a36136a3fd74bc63"
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
