class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.5.4",
      revision: "960af331a8c0a3f2e263c8b90f1daf4303816ba8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17fc0d0c48dea3a309fcb91f8af61fc948c50fe318994a1e239b937b85d90a31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "044e6fda003d8a153972c6624570459f134647f0d0d6239600afee37d0a91d54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "212f24b464949816bba8a25a369fceb30aa7d19f6c17070f7f459b73d5ce0b0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "424aaf69294b731718ff2e82d56c2493fddde06a19385e2c17fee7d9e6155845"
    sha256 cellar: :any_skip_relocation, ventura:        "b71b308216ea2181747d3ff334776bb67a2501432e560541347bed236ecab3e0"
    sha256 cellar: :any_skip_relocation, monterey:       "6f662bf07c814ad62850a2ccec5e9f9e93dc7925c85f92b68b6380496f64e6c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce268696e79e925826c43c28c5dd50e8b026fbc5b938ee48e23fe8fcdc4db6ac"
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
