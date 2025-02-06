class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.21.9.tar.gz"
  sha256 "b0d61fcaf0f2a0a9e15059ca1c54b00e52e2ceed3e3c10823e76de5effd8b1e3"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68df891be3074f4b93942ad9e8691c455503267241a524fc8f64e781cd36c082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68df891be3074f4b93942ad9e8691c455503267241a524fc8f64e781cd36c082"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68df891be3074f4b93942ad9e8691c455503267241a524fc8f64e781cd36c082"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e865957752fe1eb9b8fc9c1c76a499aa54224ae2d23d882ea04ae1be1d44f1c"
    sha256 cellar: :any_skip_relocation, ventura:       "8e865957752fe1eb9b8fc9c1c76a499aa54224ae2d23d882ea04ae1be1d44f1c"
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
