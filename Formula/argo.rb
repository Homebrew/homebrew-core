class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.4.4",
      revision: "3b2626ff900aff2424c086a51af5929fb0b2d7e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6ba59576beccd32cce45905f94048bd070822e0a86eca790db2f57fc1867f7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd2b03bff667cc2dc395a91a5e9868936e8dd7df54dda416934bca9e8fa51f79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "628a916960dd4120b2102d0e55d1c1582aa1bb8dea4a33143e3854a9e007d30c"
    sha256 cellar: :any_skip_relocation, ventura:        "cd2c3641b2c20356a751671681b72d7349c02c8ead068b68a619874d8125d58d"
    sha256 cellar: :any_skip_relocation, monterey:       "37a7a90dccf7dad3c20b30d97653cceb3b84fc69d606e8e6f849cac80e2adc2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3d3fb03de534b3b669f77007ebf637963d9d79f18c77cabe1d1944e4bef44b4"
    sha256 cellar: :any_skip_relocation, catalina:       "dffc23f28ad5d8c7c281d23bec4b8ab7a763a3c792e16873704141fb19a1fc97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01147449ea975eff1ef709047f468e0eeb19938b7e6bea91a4d61f120f1a3378"
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
    assert_match "argo:",
      shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end
