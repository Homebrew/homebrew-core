class K2tf < Formula
  desc "Kubernetes YAML to Terraform HCL converter"
  homepage "https://github.com/sl1pm4t/k2tf"
  url "https://github.com/sl1pm4t/k2tf/archive/v0.6.3.tar.gz"
  sha256 "49de6047017d66dcbf7a28d3763fe927b0d3d4d36805ab942cd6b229c261df32"
  license "MPL-2.0"
  head "https://github.com/sl1pm4t/k2tf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f3774927317f0978448e3d940472350911a0b03d038eb42b00b22403238d693"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbbd1ad00e9a33863845ce7a7a0cec1ea597802871f0bafb84fa552f8e350c25"
    sha256 cellar: :any_skip_relocation, monterey:       "320f5b410313270ea831241212485b4f2a3526a781bb228a4eb0a5c24c92b28b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6bcbc8506727d4d298e4dcd1d6bb268152e993ff6c5d232471ed9b4f5af713e"
    sha256 cellar: :any_skip_relocation, catalina:       "6bf09d3fae58bf15c1af0c00e94ffbdcf4c6d41a8c0e284be33d861cd4a8829e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49d9a9995a83b40718294b21377c8a3ca9ebcf2d1c6b6bcef027d9e553d74702"
  end

  depends_on "go" => :build

  resource("test") do
    url "https://raw.githubusercontent.com/sl1pm4t/k2tf/b1ea03a68bd27b34216c080297924c8fa2a2ad36/test-fixtures/service.tf.golden"
    sha256 "c970a1f15d2e318a6254b4505610cf75a2c9887e1a7ba3d24489e9e03ea7fe90"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    pkgshare.install "test-fixtures"
  end

  test do
    cp pkgshare/"test-fixtures/service.yaml", testpath
    testpath.install resource("test")
    system bin/"k2tf", "-f", "service.yaml", "-o", testpath/"service.tf"
    assert compare_file(testpath/"service.tf.golden", testpath/"service.tf")

    assert_match version.to_s, shell_output(bin/"k2tf --version")
  end
end
