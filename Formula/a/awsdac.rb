class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.21.12.tar.gz"
  sha256 "a76dd16b75c2f3f4c2686b076aa3ac7133cc9f16669e38cb47d3f2978f4e6c08"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68b74169cb9060d22e2971e6b993f7758fe519741106ca946e4f3d9ecfebd665"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68b74169cb9060d22e2971e6b993f7758fe519741106ca946e4f3d9ecfebd665"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68b74169cb9060d22e2971e6b993f7758fe519741106ca946e4f3d9ecfebd665"
    sha256 cellar: :any_skip_relocation, sonoma:        "96d86ac180085943a1999254fd90b4b5a4dc94fef2b385cad713258e2d1bbed5"
    sha256 cellar: :any_skip_relocation, ventura:       "96d86ac180085943a1999254fd90b4b5a4dc94fef2b385cad713258e2d1bbed5"
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
