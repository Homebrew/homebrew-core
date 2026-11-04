class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "831741e5c108a9f4847e62c81af7998242e7acd08d6ff7575a7a71423575ffb1"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "61ec256492ae5ca6a4709f23f03ec395fe7ee0f40438c263c20afe767cfb63c8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61ec256492ae5ca6a4709f23f03ec395fe7ee0f40438c263c20afe767cfb63c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "61ec256492ae5ca6a4709f23f03ec395fe7ee0f40438c263c20afe767cfb63c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5c26f2dd58447424f160b3e79b3dcb2cd1f98d726281994834d2979811321fb3"
    sha256 cellar: :any,                 x86_64_linux:      "d2929d51e688f0f0826e10109b8a515912e05e32597a7d3b3c14f3575ff10649"
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
