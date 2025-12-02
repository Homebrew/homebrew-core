class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "a76cabc9e19bc86ee1f7b401a6c5a37905e9c66d297a6d20b9bc9d8eb7593d50"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0aed2dedca03358420b13e6f052bb82cfee17901bfe2cc7eb1bbf538118a852e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64b000dbdfda7f37130c5645860d859cff483134b30a25827b62bd97450e74cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c74ea17a1ae280e38c216c607b6cae49498fe9f6dabac9805e33b1f43412b7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9319e6b87cdfc0ebb6ebefd59cae6bfcb2b98ea4e2237db035775abeccf97f7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d46e56b179a2529191545fda3b3047e696c48fbb702a608798be060e3d83609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d93cd91a2526cc4819f6b3bd6cc39376272d9c33f3a308de0517682d1e20ee1"
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
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
