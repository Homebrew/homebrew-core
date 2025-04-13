class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.21.10.tar.gz"
  sha256 "deb30b832ac74bf0b52d8e61497ef4d99b426a02b745e557bc5b06d81d96388b"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a3b1fad9033b3fb83a3a4fd2799d141905f74ce8f225df02cb5f78a115b7895"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a3b1fad9033b3fb83a3a4fd2799d141905f74ce8f225df02cb5f78a115b7895"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a3b1fad9033b3fb83a3a4fd2799d141905f74ce8f225df02cb5f78a115b7895"
    sha256 cellar: :any_skip_relocation, sonoma:        "e391812931e9131f6488a8940476a36943049111a8d7680378009537ad6d9598"
    sha256 cellar: :any_skip_relocation, ventura:       "e391812931e9131f6488a8940476a36943049111a8d7680378009537ad6d9598"
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
