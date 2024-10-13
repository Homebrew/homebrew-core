class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.21.6.tar.gz"
  sha256 "1b3e955eb9df643246d3a9b88d2b951b0eb5cfb9b3d667ded2a4dbd5476551c3"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adcac8fef947c7328f92f04c88f6f6a03f7850ff6eda76e8c61641b801aa30e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adcac8fef947c7328f92f04c88f6f6a03f7850ff6eda76e8c61641b801aa30e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adcac8fef947c7328f92f04c88f6f6a03f7850ff6eda76e8c61641b801aa30e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "341ad9e33312dde036869e78abdee6e39c13d4e48c5fd574031b0421e4386949"
    sha256 cellar: :any_skip_relocation, ventura:       "341ad9e33312dde036869e78abdee6e39c13d4e48c5fd574031b0421e4386949"
  end

  depends_on "go" => :build
  depends_on :macos # linux build blocked by https://github.com/awslabs/diagram-as-code/issues/12

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/awsdac"
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
