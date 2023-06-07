class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.53.1.tar.gz"
  sha256 "4f32c3834897c71f4933687280cbd10989f7e2953224f3cabfc81431ce001b02"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "379a6076caa600046ed514fcf0c34513f06765e32b95ba9784e9b884a56c9a78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e01df3162e846c69192ff86a5095284cb96e9b03352d63424d833424d5cb3ff4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23dfff4899b29cb150a15be26760eb7bb0f6f4a8e1283bac0fa93c2a3340d88d"
    sha256 cellar: :any_skip_relocation, ventura:        "b86c8bafc29a007bb591c0daa865b9ab65a5fb3d3f48997761ed8278919be8b7"
    sha256 cellar: :any_skip_relocation, monterey:       "1e4bfee52a9fab810e02747bdf2c30b8ae4eaf53993e0f2982ef677a86c18d3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "20fc874ca81eb08184f584b38ed770927386dc9bde3b2d1107b65bbd38e26a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5591bafd47395d52f0189d94d0c8faf678a0190a38311ba6421e81b25789c7d"
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
