class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.8.42.tar.gz"
  sha256 "2f940b982ec10dbd5464a4c65947a022a345b1d76b5c0446dae1cd2459eff669"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/ctlptl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f65690a21428923a104907bf1f36d68fe5548a8d1818bdd2c6b9d70ce9dd3c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95a9e91c72dc187882d2535aac2e1be20ee15b562434b087cbcba5bd282e6fb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eecec056b5b5043254277ef00a8b2932996ea9a2df185159959f91fe1ecf100e"
    sha256 cellar: :any_skip_relocation, sonoma:        "56d950a9ca79bbc3bd4d86a61c6364f7977a74c8b51c76c45a5adeebe46552cb"
    sha256 cellar: :any_skip_relocation, ventura:       "a191ccf424740643e74d5cb4e9e8b3a4837cad39fe5751a6ef9562eb9deca4b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d1b016bf961588b50c6727a161afad481658bf78bd0c3dc099a2dacef6a6a2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de48874a9cf5ae452d730dfa21b239ead2c042396e056a4b571c03fcf44ae14e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_empty shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
