class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.31.0.tar.gz"
  sha256 "b2faf2b4bdf011569c27774167e8910d94dbb041f42456b5f1c5ce060958065b"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c30db9772d245f63b2932774b10278960ef25ab0032a6566df305f569853e0f9"
    sha256 cellar: :any_skip_relocation, big_sur:       "52589290661146910c2f860d2ffb05c0c3f220708f16280409108307914bcfcd"
    sha256 cellar: :any_skip_relocation, catalina:      "5f2e9400f78aa5a6619844dd8a12ab3f4b9ad1cefd598eb3d4912769ff649f1a"
    sha256 cellar: :any_skip_relocation, mojave:        "bb8303eb0b07c74437d47afbbb07ca152172b3c2c2caf35cf89b72c1f5cbaeca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "562c7a3db7a033e0d25236b7ca47241a2671e40c3ee4adc4328c8c23f250d6f4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
