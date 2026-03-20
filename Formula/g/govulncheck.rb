class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "da1a7f3224cf874325814dd198eaa42897143fc871226a04944583cb121a15c9"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9a5b2cf2c4b2c959f68f0d72b66ffd67c890a2d5fe9c544766aa5f1f46f1c62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9a5b2cf2c4b2c959f68f0d72b66ffd67c890a2d5fe9c544766aa5f1f46f1c62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9a5b2cf2c4b2c959f68f0d72b66ffd67c890a2d5fe9c544766aa5f1f46f1c62"
    sha256 cellar: :any_skip_relocation, sonoma:        "d60b984e2b4f3c5822d7737f7db72f461b7cb53574b5c8def426842024cd031b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de97f5e498197927e4815f4362b22b38b164cfb6742d4788646726afd3a8b6c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff45ac7b3a248f827e4b183f0d328a1e0f9f21311b36c33c51dccb6d7a0e0549"
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
