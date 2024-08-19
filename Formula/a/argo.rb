class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.5.10",
      revision: "25829927431d9a0f46d17b72ae74aedb8d700884"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6feff0e683efdc86c676d290a6802ab61616271dedac045c8eceea85f9b74e9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cde528db5e9f77e347efafcb9ae34517fd442b149b48d6a2f8e62d1fd3dfd4c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab3422e6c294036dc6a5eafb8dd364ee420f7989c284d2b77edb65a61dda09ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7434cf6c93a19b25a085bff735124e0c8beb7820000a8ecb95c15cf7284f6d4"
    sha256 cellar: :any_skip_relocation, ventura:        "95544b9189ade74a1f0a890b11a8fea767fee972f53989b399026bc300f13c02"
    sha256 cellar: :any_skip_relocation, monterey:       "af584bed20c0842a94a66b8481369b31b53e75258ba081ae27f1e84f8014312a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9512a4d33570fdfa02a32bad9498fe553de91f918877daa8535b33bd80b5a04"
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
