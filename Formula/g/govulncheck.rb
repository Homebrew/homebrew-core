class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  # git checkout needed for buildInfo support
  url "https://github.com/golang/vuln.git",
      tag:      "v1.10.0",
      revision: "ef4cb2f7cae47fe3e21fc596455f694951867b29"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea4dcf1babbe15e699ca06ee9a7b34e91d21b1daa4e7d56b60e9c912d360eb7f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ea4dcf1babbe15e699ca06ee9a7b34e91d21b1daa4e7d56b60e9c912d360eb7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ea4dcf1babbe15e699ca06ee9a7b34e91d21b1daa4e7d56b60e9c912d360eb7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "84587e3f1f9869857c1ff7a6099c951a4e61ce2256dc8de84de91b32cf5ef50f"
    sha256 cellar: :any,                 x86_64_linux:      "121cbf02bd90bff945cba870e19fe489638d4f8fd0fa364395d4999ac2349dfb"
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
