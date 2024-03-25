class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "6e7a87913f963afc349c8ee9da5ffa6732856df6eef63c930db72c3de1812f7e"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0391e660819787beab00a594bb72725c1b704180699bcf21876da4755b4f66a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52eb89a46a9f25eb164d9d4ae7db9c74b1da0f5867a0328056f38b262217159c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33d06b0b7bfd317e59eb410fc6b032208fb9c889452f49600febff8a3482e3c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b324efde598d55bdcfa458c1c944448fac8183bba7f897fb0aad3ce09db15c95"
    sha256 cellar: :any_skip_relocation, ventura:        "c5cb178e4bf3d4fdf4f1778174746d11cacbf6ac415d53aaa3a44b2e3ab83c75"
    sha256 cellar: :any_skip_relocation, monterey:       "9da84743cf68da97368e43f240f32163d5a2cee9eb3e8482d8d30509dc323a84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9d2b8a252344f620a8726d83f6e0ad9c43dd53b100ed16946379379ac3e14d2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/cfn-format/main.go"
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}/cfn-format -v test.template").strip
  end
end
