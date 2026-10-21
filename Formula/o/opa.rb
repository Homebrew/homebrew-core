class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.21.3.tar.gz"
  sha256 "0bc24f8a2a14fd698f3fe173588c4394097f14d3fcfd3b6f7aee82008d73c8d7"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2615d6c686eabcbd3cff42e851ac0830100da14eb098e63e577d2d3c59f90c70"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "872f533434821a17a7e4bbb6d84356196fcb740051cd4414d59a2ee6f1f5bce7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e4f225f4738f0dd38909f7b202b44d233234584dd5aca4c1fa444f3619703878"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "32cf86c5efa78e1c75abd632a65c6d54e43ea4bddf4cf1ff07fc696157a2cb33"
    sha256 cellar: :any,                 x86_64_linux:      "01a5895a2db9ee5ed274b8e074e0dfcc78f04a1f689c772f945facdf845081ae"
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
