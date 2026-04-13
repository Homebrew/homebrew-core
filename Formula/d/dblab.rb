class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "207e33ab265d2e90e1172869dca121a342b656d08b39340372ec783e8ebe1c06"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59da440a552360de2d7212b221f6e47a3fe12ae5adbd8de41776168a25373e20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62ba6319aa17df9565c68112f3fe135686c52dd795bef930442cd7d0d4882819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45f966ebf646086c5d4762f156e687a9c0004ddd387d1dc01a26af09e8d27138"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9d05cf7b8c229e430a145c88e5bf360920c930e9d53f15ba4570b4dc17c43b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b8093ac7a50bba1b4f21735c4309e74428442ea1fac46efbb95cb56b54bec56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cac7e36c6bde94473176b7b9674e9c71e34fb8aacb7d04a3d72a5c92223aba70"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
