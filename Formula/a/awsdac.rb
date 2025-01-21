class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.21.7.tar.gz"
  sha256 "626cc531b5682b7f08513736df76a060c9272066f87156bf94194d6c1887d018"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28f8cfe265c549e4df24ad5e9eb202c4e2211ea56bf7a3a52071013aaf4956ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28f8cfe265c549e4df24ad5e9eb202c4e2211ea56bf7a3a52071013aaf4956ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28f8cfe265c549e4df24ad5e9eb202c4e2211ea56bf7a3a52071013aaf4956ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c10a66632f66b680f258c05607916fd64ef3f98cd9f88440aaa430f73b2e2d3"
    sha256 cellar: :any_skip_relocation, ventura:       "0c10a66632f66b680f258c05607916fd64ef3f98cd9f88440aaa430f73b2e2d3"
  end

  depends_on "go" => :build
  depends_on :macos # linux build blocked by https://github.com/awslabs/diagram-as-code/issues/12

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/awsdac"
  end

  test do
    (testpath/"test.yaml").write <<~YAML
      Diagram:
        Resources:
          Canvas:
            Type: AWS::Diagram::Canvas
    YAML
    assert_equal "[Completed] AWS infrastructure diagram generated: output.png",
      shell_output("#{bin}/awsdac test.yaml").strip
  end
end
