class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.3.2.tar.gz"
  sha256 "db9c0c72d2e6a5e0d0114b9c6e5a33f32ad4aad9e80c9dadacab2b7e9c2de35f"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d205b7a310c6c9f64f5fc2f5ec9e8430c752439f080f9bbc9992743457436765"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9ad9cc064cff7f92bfcbfeba8b11d597a4ab2ed90caaf3d86c9e1b4329639cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f1b0e1d394b121ba2e777515bcbc94b04ac295daddd15a8d7eaefebadcc2b57"
    sha256 cellar: :any_skip_relocation, ventura:        "9525371cbbe57fc75cf2e99985783e74676f0fbff5aaef01ed066a7474c95e4d"
    sha256 cellar: :any_skip_relocation, monterey:       "04a234573e8996798990bac20419effc0bb0eb1ae341c13fbf98ff38511f28a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f9f4f33ade56a17d228890c53c396c24366703209818ac4234876eb9799c441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc1938e7f74d7c83f2df21033cbe1fcb79d6f99ee5857e14aa323a3034776709"
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
