class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.21.11.tar.gz"
  sha256 "7e95c3a28f2827c5a78764fad5c61934f94f1361e62ea52fb52a9e100107c6fc"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86e74ee27562f37c22ed2faf5d6acdc7a72a1f99785aa1892be3a3b1866568dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86e74ee27562f37c22ed2faf5d6acdc7a72a1f99785aa1892be3a3b1866568dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86e74ee27562f37c22ed2faf5d6acdc7a72a1f99785aa1892be3a3b1866568dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d1e613c9b52c4d6d55049e3744275e6925361ac300f587f3a52d5fe042c4b7f"
    sha256 cellar: :any_skip_relocation, ventura:       "8d1e613c9b52c4d6d55049e3744275e6925361ac300f587f3a52d5fe042c4b7f"
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
