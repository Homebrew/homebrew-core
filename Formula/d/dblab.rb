class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.55.2.tar.gz"
  sha256 "b744a9eb38a76a4fb0670d22de7abbefb27e0edf1aaa63174ddc29137dfbca5b"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "31503aa280eb13cbfe0e61cdc43f4e3ed320943c48bb5b4021c4757b16280d1e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "31503aa280eb13cbfe0e61cdc43f4e3ed320943c48bb5b4021c4757b16280d1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31503aa280eb13cbfe0e61cdc43f4e3ed320943c48bb5b4021c4757b16280d1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d985238c7f744ef04fe1a1454513dc0016eca2497043fb690cc03d0b1981c33f"
    sha256 cellar: :any,                 x86_64_linux:      "b7e052fc3dc3d40e81b0e10e4946d2a9192e132d0bd440e9cd145510573ab5d5"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
