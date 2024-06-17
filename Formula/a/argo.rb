class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.5.7",
      revision: "503eef1357ebc9facc3f463708031441072ef7c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc961172f6126a531fee1c42bc44a1eb89e27b6d2ef4a4feb2b511d5a5ce03f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b312695788e421df89749f24c0fc29b38388e02bfa8d8dbaefa12dce6d58efb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4abb8f979110f1030ba1d9eb17f64f44cdc6d74050546863370c97308c0858a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "083db0c9b0483cf5acc6ba40ece03d32519841fcba115d47906b9fa6610f3de2"
    sha256 cellar: :any_skip_relocation, ventura:        "01f51eab3872aded740b2b1850ba44aa9f175cb5a8efcf99d955f797ee27aaff"
    sha256 cellar: :any_skip_relocation, monterey:       "430c6f5cef4175768374ae4d1698e63a467d060aad2a7f25e55fb6c336d866e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4f20ace14e0554a04488957d111eeab08179f5d0a2dbf62c428782619541c7c"
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
