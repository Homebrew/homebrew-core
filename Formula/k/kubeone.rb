class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  stable do
    url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.9.2.tar.gz"
    sha256 "642ac0217212374fa584fae47856646ce52e5a63484237c899578ac854136311"

    # fish completion support patch, upstream pr ref, https://github.com/kubermatic/kubeone/pull/3471
    patch do
      url "https://github.com/kubermatic/kubeone/commit/e43259aaec109a313288928ad3c0569a3dfda68a.patch?full_index=1"
      sha256 "3038576709fc007aece03b382715b1405e3e2b827a094def46f27f699f33e9fd"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8f3db4da01b8ae89b004406e754edc0c26c090820491a9d69e8e673d8660e99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e64c98e12b80214ce48acf9c05fa7baaf5fa2c7aa99c30e3c970e81677c16e02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4e9a67772d726b8631d58af17e0e3961a64c02c72ea3e6b8f5bb4b48beef873"
    sha256 cellar: :any_skip_relocation, sonoma:        "b373e65309bbc45ae8e5ca8c0b8232b0f2198087c255cc8cb8e074148dc21574"
    sha256 cellar: :any_skip_relocation, ventura:       "2fd592f52fbbf6904f1252b801e2b5521e47d9c06d8bd0bd7c6684796f412682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0801236906327bc1991e782d9e8b3a2d851486c0204dad163350b59899205c0a"
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
