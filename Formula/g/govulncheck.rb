class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "94510a4ff2691b13fc217381389b8aaccbb54857058ef528a1c2192de7ab1e41"
  license "BSD-3-Clause"
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa2d4fca7b6d90fbe93e639a11dd88f587590600d6bb321f8b7f57a56eb2e0fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa2d4fca7b6d90fbe93e639a11dd88f587590600d6bb321f8b7f57a56eb2e0fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa2d4fca7b6d90fbe93e639a11dd88f587590600d6bb321f8b7f57a56eb2e0fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc2ac915158fa53d0d8686ade6c50dcc77b6ebfb691b5fdfa93b140f281fcdfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "225264750132e3726a72746b8977a47f6ac2dd95028b648870890c20d1d2ecb5"
    sha256 cellar: :any,                 x86_64_linux:  "482f95c0103c1b89fde6c8b66941f006b11eb1b32750e9f6d6c2459a06d06b6c"
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
