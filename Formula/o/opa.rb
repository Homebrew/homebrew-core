class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "a21e3dceff91c079af1ed30e84ca8eb365bbc1cf2edd68246cf91568968f13e6"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5cd14f477a82a73de85543241877c21d1c06d51a582570b87df5ee88eabbb836"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70a2d46cd957207f0f64e2ae42e8a4b6bbf65e2233c2bfe045aa38fdae7641e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d48996b110fa8a8fd8a851a503cec2233da427a8e355ca2d86143f0f7d8e491e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "513ae90a4fb429a3acf9aee6bf8b16386948bde085cf539ae18b657b5de31845"
    sha256 cellar: :any,                 x86_64_linux:      "eeffa6a880db2d7efe1c5d19067c9ad6bfb7ea429cb6fe17be9dff5135b0fbb6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/open-policy-agent/opa/version.Version=#{version}]
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
