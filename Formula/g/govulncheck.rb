class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "da1a7f3224cf874325814dd198eaa42897143fc871226a04944583cb121a15c9"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4a863eea82be9c89d65b9daa9af314066d5260b2f25c578d55fbfc6b35c2371"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30a8808b70ce289bc91e9ac05745cc71d2b24c97bc73a017824c90f90c2a823c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30a8808b70ce289bc91e9ac05745cc71d2b24c97bc73a017824c90f90c2a823c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30a8808b70ce289bc91e9ac05745cc71d2b24c97bc73a017824c90f90c2a823c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4b7ce4852325b7ccd5c6955eddbfa87fd9bf97a8be3a16f353ed1d7afa99cac"
    sha256 cellar: :any_skip_relocation, ventura:       "90ad669d02c9fd04df0fcf5b3a3a7d8f87ffe7a501b68d9cd8af07ea6cca82db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d866244854306e8b5dce984104a7b15a66ea549caad270054175db3328fbaca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f72776dc2ee6aeda090982a183b43182ca390c7b5f16a8867b52da01b86d33eb"
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
