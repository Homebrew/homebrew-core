class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.6.0.tar.gz"
  sha256 "c29365570082ee15f598c1a0af46541e42e77651f13e0ed5adabb67f8cb80ff7"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e41ef741c9b0b7418fb68617e0364f7709be6c331175ebbe9ad1dfcc516216c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9575867674f9df9b285026cbbe9aa42b9a46438d7931fdb1bd997348f8970d10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b85ab414663b28102d887569b90ae52306f39c673765fc9d743935d2afdf9a01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80cdfdd54e36338f36eeac0d013617e2888a96086a9ac22ea19725a097652ea5"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9dd7dd2c67ed284141c5f8e6b132be3229bce2c82bb6770508009e50631a40f"
    sha256 cellar: :any_skip_relocation, ventura:        "e9f435c5cc45c0283ca3502ff48965e55f2a03c7ffb2c494e8af599b5adcc5cb"
    sha256 cellar: :any_skip_relocation, monterey:       "9456a587256f675f56f776c9683f4110f3d7e4ec68828f6951ab2380697f4d23"
    sha256 cellar: :any_skip_relocation, big_sur:        "aec51b685c06ef7a1a50aafc849afd1c1748147b65974f2307a35ad69387589c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1f4c74a762179325c2beb5130df933d75fcb1da8be41d7487da84641949bfdb"
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
