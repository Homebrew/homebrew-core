class K2tf < Formula
  desc "Kubernetes YAML to Terraform HCL converter"
  homepage "https://github.com/sl1pm4t/k2tf"
  url "https://github.com/sl1pm4t/k2tf/archive/v0.7.0.tar.gz"
  sha256 "f1422861041d2a6eb03292ecce21002ad70ee24fb8ef6ded0118358a3204ce17"
  license "MPL-2.0"
  head "https://github.com/sl1pm4t/k2tf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fae4ecfeba2b2a0a70b8029856a07b91af0cc54534ae0eb526dcd0eb7ef03b38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4d8b67c6c889d4e309bc92f387ca32539460de38df6b7d37d46dbc020d24c6d"
    sha256 cellar: :any_skip_relocation, monterey:       "0be13024e37cde90792989744d82eec44558f34f1a8537874a36031c13bf6656"
    sha256 cellar: :any_skip_relocation, big_sur:        "7031f0ba068d3425128ed2b23ae8ac6cdd7578a335fd7375abecb3f5537984c4"
    sha256 cellar: :any_skip_relocation, catalina:       "ccaa5b31b3fa878f8917ff1d6f9c16246894f0c9130f1ed9c4072b94dffa08bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c70e4d8b7f97a28091a7c07ba2e3411dc040a5ab56bf2d12b13bcbb6bfa53ca8"
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
