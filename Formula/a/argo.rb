class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.5.11",
      revision: "25bbb71cced32b671f9ad35f0ffd1f0ddb8226ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77aa17fe5b571850fdfcc3ca7766a2e2e02eb2009eb34a096befe185e92cb48b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e5cf3e1140a19c9d1beaaeea7642e443a524f29d4fa816b66b2cd123142d45c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6eea7cc3536f79db1a9fe0b2a51119fe973bda019a61d73d78672450466160bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "57231ce51c94ab19611689d0a58991b3462621f107ca4a3012f4deccb83d4349"
    sha256 cellar: :any_skip_relocation, ventura:       "81f4bd1c9383a332003da27be247665fd1fff9f1162fb0a980efc65e8c981e6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bd4dd91546edebc07698250d35b37028610dbc03c277a7eacaec010097381ef"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"

    generate_completions_from_executable(bin/"argo", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argo: v#{version}", shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end
