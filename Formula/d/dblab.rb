class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "831741e5c108a9f4847e62c81af7998242e7acd08d6ff7575a7a71423575ffb1"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d8899bf2bc3f054cc6b5b32ea892f2798a6485673944dc594947b33e11d094a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d8899bf2bc3f054cc6b5b32ea892f2798a6485673944dc594947b33e11d094a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d8899bf2bc3f054cc6b5b32ea892f2798a6485673944dc594947b33e11d094a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "34294eaeafdeffe3ddd94f56aab149fc6c3ce0117da74060aedadaf6dbab799c"
    sha256 cellar: :any,                 x86_64_linux:      "15cff1b6b0467e182ee4bf601cd620b600a6590be642f5e2ff7bab165ac27193"
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
