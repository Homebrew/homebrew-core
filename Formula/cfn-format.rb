class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.2.0.tar.gz"
  sha256 "064bc2b563c9b759d16147f33fe5c64bf0af3640cb4ae543e49615ae17b22e01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "746d5b7a5493b01f9263de7ae57d14f7debcc09ae37ed9b88e3ca94e71cccb96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae53259389b4dfb638b10beb48257b7edaf84797b2b1873cb18ce915c61cc8ad"
    sha256 cellar: :any_skip_relocation, monterey:       "199c21519edee486abacdd7f7671142a6559694cc6b4a6743a67ee469440251b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4907e241905aad8457ae6eaf09e1d45e300d27776d95c0a9ee658dc0551c1cc"
    sha256 cellar: :any_skip_relocation, catalina:       "4769eaf270502dce3598a91f2d2a67b4913f9ee2fdb17b715bcf5bd6e861bf72"
    sha256 cellar: :any_skip_relocation, mojave:         "53cc76c61dc8e73690794be8f04611a74e0eb9391855b1fdfbe2cc684604eb0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0e6bc6e76b5e2f86e578b6443dd8d98e3ab2b55ea5fa28a62266e74510a191d"
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
