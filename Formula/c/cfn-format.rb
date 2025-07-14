class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "37fb974ee0eb36ceb80f38f13141883f3779a81c79562d0ad15afcd74753485e"
  license "Apache-2.0"
  head "https://github.com/aws-cloudformation/rain.git", branch: "main"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d80d5ebfd7bdf016d23d94f2920dc15047432c4d28b92e79c04f8380c10d0e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d80d5ebfd7bdf016d23d94f2920dc15047432c4d28b92e79c04f8380c10d0e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d80d5ebfd7bdf016d23d94f2920dc15047432c4d28b92e79c04f8380c10d0e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c099d1a070b7e49d77c97cb34792a3abad5ae2f29609258646835191a426efd8"
    sha256 cellar: :any_skip_relocation, ventura:       "c099d1a070b7e49d77c97cb34792a3abad5ae2f29609258646835191a426efd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0594cf1b143356dc4d4b586dbbd5ff9a8dc67b1bc329666e9657d7987074a2cd"
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
