class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "d0930fa6ba78b3941348b6949ee999c3de3ae87f328b7be3a8e40286cf2858bb"
  license "Apache-2.0"
  head "https://github.com/aws-cloudformation/rain.git", branch: "main"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "838d301afaa6757e5affdc004cda9d4ee6ba41f48f6f4f5178bae106ab9ef2cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "838d301afaa6757e5affdc004cda9d4ee6ba41f48f6f4f5178bae106ab9ef2cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "838d301afaa6757e5affdc004cda9d4ee6ba41f48f6f4f5178bae106ab9ef2cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddb66a96ef5f6b13a1e8738e6d0be7fa6e56bf8a95121a3c18da00f3a93fc180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "209f363fd47b5f11acc3a30ebc3118f3d13e090b2f54778fd2cee685b648925d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5f042666f1c4e37a08ca0dc464baa76220c95b1bcc54b93f4fad70654625461"
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
