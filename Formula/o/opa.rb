class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v0.62.1.tar.gz"
  sha256 "fe74a378cdc248b4feeb699af00ee20c731ffd7c817b40b02ec3a161be088218"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a43cf213d79b91cf762003e7422d331885c5ee9f800910225b3b8774cfcd74f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46794a62e97d7da70fc8f09fe28d0b8d6b2cca1758913ba925dee73bacf6d082"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ded5d7fdc70baa009a61b209e8a251653433f6fa8f406b81396161224a730c2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "adb0ec838b91cdb1d99d09f3a81d3752e30c235b5c5252111556b6ee87fb1f79"
    sha256 cellar: :any_skip_relocation, ventura:        "39ffd28404923a356c4306bec89874140ed9cd6bd937e34e4a433062a89fc798"
    sha256 cellar: :any_skip_relocation, monterey:       "4fc719b669da46e17f2170425e73011440f8292f5bdc5996fa00220f7ae85ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faa076e5f9c95f47435e713f9fcd2595075347663be738f082e15a0c2fbede80"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
