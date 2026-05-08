class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "57965af14e2579ea44928070aa04251ecbb1fb4e206c208b4aec6f803ca36b5a"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1980caf8d3520239bf16b063ecf414008ae7bc0f7ca587f851efe8984d99aa75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1980caf8d3520239bf16b063ecf414008ae7bc0f7ca587f851efe8984d99aa75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1980caf8d3520239bf16b063ecf414008ae7bc0f7ca587f851efe8984d99aa75"
    sha256 cellar: :any_skip_relocation, sonoma:        "ced5af49e1354f4cdd39a26c8920abe27a42ed47a3959b3eae36df56f9437835"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b1327b079004d076d84d9463eac18eaa14589f53908d3ba2fe5c36873648ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85e893e3e50f256ce8b4cbc141dfee62ca43ccd08bcc80d8726c059a1f993911"
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
