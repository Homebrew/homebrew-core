class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  # git checkout needed for buildInfo support
  url "https://github.com/golang/vuln.git",
      tag:      "v1.9.0",
      revision: "e672cbe8fbc8c76e28fcb6db0efd9ce354e0dac5"
  license "BSD-3-Clause"
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d24c3f3420ca2e70f46a8a48ea5433fbeb0830b2ff029db911a3bc01030e3e3f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d24c3f3420ca2e70f46a8a48ea5433fbeb0830b2ff029db911a3bc01030e3e3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d24c3f3420ca2e70f46a8a48ea5433fbeb0830b2ff029db911a3bc01030e3e3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "48f33b3dc5320ac2a2e69433d032a19197f40bfc397ad94980805253eb97066d"
    sha256 cellar: :any,                 x86_64_linux:      "5dc40b17bde1f1a8e3e0b17b0772f113758e49b6f1ae12f9c085a81604b2a151"
  end

  depends_on "go" => [:build, :test]

  # `test do` block queries the Go vulnerability database
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/govulncheck"
  end

  test do
    assert_match "Scanner: govulncheck@v#{version}", shell_output("#{bin}/govulncheck --version")
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      (testpath/"brewtest/main.go").write <<~GO
        package main

        func main() {}
      GO

      output = shell_output("#{bin}/govulncheck ./...")
      assert_match "No vulnerabilities found.", output
    end
  end
end
