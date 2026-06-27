class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "8a2e7a2aa13263ed58198645c89e87b8a589405afbfb1a4b8410e9106bf5656b"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86f6ee2162b4576a444f25ed2346bace8727d10f3883e936a49eb403c97f5207"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1ae22648a0eda016955ef91835edb607db0a037a098441cb314942d6f8d9d2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19d3d582a983df2c1a138012199d8150dc0c0492e7b67a045b16cfd4c2d37fb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "9505e7a1640e7336416ad068b142e6ab3ed924158ef1b3fe5bab38d5c319aa05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a913bea68088c2f8861509d75931bb436cf8c1b444bf7cfdc23b2002cf57087a"
    sha256 cellar: :any,                 x86_64_linux:  "dc812791584fa97479a07681962aa3fc064aa3e38d6796dceb7773a0ffee4cae"
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

    generate_completions_from_executable(bin/"opa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
