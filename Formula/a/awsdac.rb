class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "fe126647562da6d7224f39c2bc9ac2a9312e991abd70cf8cc245c8489034a5e7"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42a67e092b82b8cd7a3defe3cd8d7b7b05b89c84e5c1bc2f12c281223484bbb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "715facef213e12c47654832508dbfaf681442e30b3dde3c62698402984f72e48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcf0e55e77a710f7696ce87d735ff7801825f35d0f8ca68622cb7f30bae391b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6d8d703e972a890894f57ea95847de274661c42064f5cb86aa51306df418339"
    sha256 cellar: :any_skip_relocation, ventura:        "7358fcbc349a28c8b307c7883cfe7473947fd3aa5896c81ca9bf804414a465d7"
    sha256 cellar: :any_skip_relocation, monterey:       "7cb0d816e88b1e838f3a2812b3b4c7c9bf5f1edbb0edd522fcd6ea2a086ac5c1"
  end

  depends_on "go" => :build
  depends_on :macos # linux build blocked by https://github.com/awslabs/diagram-as-code/issues/12

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/awsdac"
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      Diagram:
        Resources:
          Canvas:
            Type: AWS::Diagram::Canvas
    EOS
    assert_equal "[Completed] AWS infrastructure diagram generated: output.png",
      shell_output("#{bin}/awsdac test.yaml").strip
  end
end
