class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "bf2f5d0726cb73fac406701c3aa6b759a2a3addf9ddd2d9095b39caa4afbc285"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ed4de95daaa40042f287cb15df2339d28aa6689aca126c2e602b83bee3f40f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ed4de95daaa40042f287cb15df2339d28aa6689aca126c2e602b83bee3f40f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ed4de95daaa40042f287cb15df2339d28aa6689aca126c2e602b83bee3f40f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "205a0183a14e049351a3451fb452d2f3fc22e4f8b06d310ebea6b0f695dc581e"
    sha256 cellar: :any,                 x86_64_linux:      "c78691974c0d7b41da5fba9e8915c82f40904281f9c90e54f9478f431b32d67b"
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
