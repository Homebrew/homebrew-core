class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.24.4.tar.gz"
  sha256 "1387dd8e17160a51e8c99fc6654107bcb39dc94a137338c13e4ade30a344d3ef"
  license "Apache-2.0"
  head "https://github.com/aws-cloudformation/rain.git", branch: "main"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49758cff5c060a914dd2517a7c2d2d5bae834904e76ce7456734de86f94a4d58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49758cff5c060a914dd2517a7c2d2d5bae834904e76ce7456734de86f94a4d58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49758cff5c060a914dd2517a7c2d2d5bae834904e76ce7456734de86f94a4d58"
    sha256 cellar: :any_skip_relocation, sonoma:        "e89cd6ac6c334c8d44aa294ab7a7a40951a69faf53e884d1399773ee6b57ac8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "958f5e75645ea38aff59cc8644513aa0f1d686207936e4e145a94986e567c138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38974e3efdb8278453debe03d7b12937024bb972a583ba205d81aeb2526ac959"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cfn-format"
  end

  test do
    (testpath/"test.template").write <<~YAML
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    YAML
    assert_equal "test.template: formatted OK", shell_output("#{bin}/cfn-format -v test.template").strip
  end
end
