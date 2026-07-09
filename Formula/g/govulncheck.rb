class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "94510a4ff2691b13fc217381389b8aaccbb54857058ef528a1c2192de7ab1e41"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac1cd789fe007590e13925c718966934b8a4fd16e38a00298bb6e2a6a4172b5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac1cd789fe007590e13925c718966934b8a4fd16e38a00298bb6e2a6a4172b5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac1cd789fe007590e13925c718966934b8a4fd16e38a00298bb6e2a6a4172b5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "280ad2be788ebf90c7f4602aa363bad0a47d54f511dfb6ceaa38e08a374c9b94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "097815854d5a3a482375431b7cd7974d6a970524eb912cb4fe3b508c44624e41"
    sha256 cellar: :any,                 x86_64_linux:  "4e8bfb5665ab423ad36253e640a9082bd18663046fb3043b66848b3bc9037c98"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/govulncheck"
  end

  test do
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
