class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  # git checkout needed for buildInfo support
  url "https://github.com/golang/vuln.git",
      tag:      "v1.8.0",
      revision: "709015412431dd2b5b28a53c06c70bc02d49074c"
  license "BSD-3-Clause"
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f22cf780a6d50b41748313b401fb54fb518c4c539796f4fde19261e07cd38781"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f22cf780a6d50b41748313b401fb54fb518c4c539796f4fde19261e07cd38781"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f22cf780a6d50b41748313b401fb54fb518c4c539796f4fde19261e07cd38781"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f22cf780a6d50b41748313b401fb54fb518c4c539796f4fde19261e07cd38781"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d69a4073a1e3435a352bfb8963f7be6b0faafd180bfbead0cf61ce0b8a1b8137"
    sha256 cellar: :any,                 x86_64_linux:      "37b5e860bbf6a38daa20a739a73c56981ed5623bdcafb3b0e7e92272f916ca8d"
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
