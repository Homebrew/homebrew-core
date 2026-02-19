class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "9a1d696c157d15cd95d6e360ec2ef543aa4c741e825dbaf061259b00f0c15f82"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "538f5aaaa9a66d91059b70ca231cd34a79c391b7ebbb20c4f8708fc27dfa5486"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee341973fa09b792f094b329adc6c700786ef699fa1a67a9c502a93df7abbdf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "592831d461aa866c0d1a3cc99e60f0ff64537f1c159ff0de94e74eb94b99ca71"
    sha256 cellar: :any_skip_relocation, sonoma:        "193405553870eccfab65c2632c784ce8e69b45a63a0b7c3a58bd1372bee91fa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dab65ad542de078d0bccab4944c928dd3cdd877a258e136bcf1f64db1bd1c706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db8e4a2620b92625b3b65af24ea9de08cedf3f17ac4c664552d3171eba1e6044"
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
