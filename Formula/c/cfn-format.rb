class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "59b3f60572ef108e5f651560c53be9d1ab509cbfcdc40a26cc1e1dd0cd3ce634"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0cb58cfa5bed5a7151b0e1be208527da7ae749ef6ea977bee940365c8d22a0f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6003236431fcd21e8e289e8f95ecd56dc46688346b523c5bc76c1ec455c476b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6b17a7809a1016679a439afe3bbfeba9ad6814c6bf4c418973eec775f3f1b6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e2d390b5ecdf5991c7d02b44296c62872cdfd0bb5c37124ed0eff8bdbfa5796"
    sha256 cellar: :any_skip_relocation, ventura:        "a88188403d8e718ff2252ace4af9f038e94119e9fe0717e21c336d94e418aa22"
    sha256 cellar: :any_skip_relocation, monterey:       "77c49c2fc39420bb28cc1995231fbc9527b5b76a138287676fe8782724aca2d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb8cdd983e3016c29c6eaeed65d5497badd8777f97d618380d50a725edb69c59"
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
