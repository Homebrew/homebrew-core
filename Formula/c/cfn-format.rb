class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "a49d6409eec1549c9990c5352b1fcf0f3276df7f1f10cf7686493c8be262840f"
  license "Apache-2.0"
  head "https://github.com/aws-cloudformation/rain.git", branch: "main"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c28bbbce8b5519fed959c0b2ea7a99e2b20f82f90555297a91678439ed9ccfc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c28bbbce8b5519fed959c0b2ea7a99e2b20f82f90555297a91678439ed9ccfc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c28bbbce8b5519fed959c0b2ea7a99e2b20f82f90555297a91678439ed9ccfc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6f59e8cfbb9ea0573d024a7ad6cd94bc1b5c3401edc87afdf75517d178713fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac01fe21a25a28adcb69eaa1f154477b1ad58bf1f6aa9c3be538c0ce5dab5b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6d9fa3bc5068759bf6eedd2510848bae5b1ee290fea5862c590bb5dc2cdff09"
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
