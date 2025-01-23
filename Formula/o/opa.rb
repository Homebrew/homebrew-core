class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "5255c1fb4e21889cedaa718ae68be5a6ace759fc4d1782f03f01535b627bc941"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3493455db650dde648386ae13e5135106c8af7d9032084a3b7934458c9fb11b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6f6564dca0ce258398fbe535df2c5cc44a81e5b49154960dc860974e029fd93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20a7a1f0a5aeaf57d402f23e87cb545efe5cf9eed0bc6f157d50a0d2a5c22143"
    sha256 cellar: :any_skip_relocation, sonoma:        "6811b6e93ec86b3d2203bb1cba87891b0ebd04d964f94dc490f211d9d2b225e6"
    sha256 cellar: :any_skip_relocation, ventura:       "c826d7c991fb377702a1044ff379c4586d12df287ad147c722bcafcd267758fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c21b9404ff8655f2003fd54d2718cef44b591e16ead719748746ddc4e88255e7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
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
