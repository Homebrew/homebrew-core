class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.5.0",
      revision: "bf735a2e861d6b1c686dd4a076afc3468aa89c4a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "360b0c58718be680e74c6d80588a29bdb92e2fc5184e12189ba1ff8d6a3e8103"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "210676894fd38404a8193dc7e8ef4164d0d94e0b71203efee60aacf0b5d8638c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06db6525ec402b2688044a4a47ba88310fb38f5443485aa435ad334c05191670"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c51f05d7d832d57486fb30c4bb0a3c98cb3728e3120942479bb35c17210afac"
    sha256 cellar: :any_skip_relocation, ventura:        "eb57af6a3dfe964b1ce8f97bfe6dcc0038d6c2cbdca403df8a4f874f2bf960ae"
    sha256 cellar: :any_skip_relocation, monterey:       "c39a208356544cf7f470cde81adc864a0cb13435dd8442e31c00c7623a58784c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b0e5616b87e67eb572a4718977f53ad504fb1ddd02eb494a2a5e8cf5be53912"
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
