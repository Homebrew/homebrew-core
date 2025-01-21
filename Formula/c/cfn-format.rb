class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "1bf031347ff0e3f51b16575639c6e6fc64fd2e7979a4f7678bfeb313fb5a2c7a"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1943f596de0243ccedaa86623f07a9e71d140b75128f7cfd7e3105ca5ec0aef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1943f596de0243ccedaa86623f07a9e71d140b75128f7cfd7e3105ca5ec0aef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1943f596de0243ccedaa86623f07a9e71d140b75128f7cfd7e3105ca5ec0aef"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe5051fb94a5a51ba7d893cc727f2a3693ad13a9d8ab5532b03cff051b2cd690"
    sha256 cellar: :any_skip_relocation, ventura:       "fe5051fb94a5a51ba7d893cc727f2a3693ad13a9d8ab5532b03cff051b2cd690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03f359e039edbf0a71a22798d309f2bc1f288d58bd0175df266fcffd6a18732e"
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
