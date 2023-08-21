class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.55.0.tar.gz"
  sha256 "4db886ffe0cbe20b58631befdc9a46a336525e6d88aec4fc9c29360d0d0bfd6c"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee04fbca8ff56d7856818a198c149d2f48515cc75c6269d8b9896b1dc2dde4cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67b459161faca6638ad66c1eb75282927ffc8293ef41f6df6a3728ef68f0a364"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1baa56cf35c904a58ffd695af711030d286fd19d06218c5e1c2cada079e24db3"
    sha256 cellar: :any_skip_relocation, ventura:        "fe65f43771936dcb2cc811a444f459b38cb265cac8e88231934c94234eb2c2d3"
    sha256 cellar: :any_skip_relocation, monterey:       "f27c49400281dfc81f2a2426e625c5ee9e23ee75ca57e7232975d16a67d5e6de"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4701d6aff37d483475ec7e655d53d73f48a36a0cbccc18e1b012abde9aad1af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e885da8762f8754960b144a98b0b84814ff563dd7fc5c64ca499c5ceeee7642"
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
