class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "7d862fb8d91785d5af4cd29ef55813feb1db3977de4242371d3aec3fed49309a"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "324acc76f98f00615001c3895e215d8c9ac293752c2fbc3f13b7402da9f51e85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f2ecd2fcd83e3b9e17b2e8b1dc1e757400940ce0d7f649c719b09650a9c9461"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a84ea1380a267674dfcfbd1561ec00eb9f54b08b310cfeebd21fa722a989acd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccc21b6c6b153e63940dfc653040a0a7c62369eff9d10493d3c726b768a66389"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6a110b06273323b70dae049474ebc325d2faa68e7c16705686942c573c0a19a"
    sha256 cellar: :any,                 x86_64_linux:  "fe8861b6c7b73dec10613c8e821df62cd3ae5c10231c689548ad8ed165de96c1"
  end

  depends_on "go" => :build

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
