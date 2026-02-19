class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "da1a7f3224cf874325814dd198eaa42897143fc871226a04944583cb121a15c9"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b18b5bf0d002d7bdade7ad5525e4d4b13ffe1ba5dcd7c7e559b9e97e62941d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b18b5bf0d002d7bdade7ad5525e4d4b13ffe1ba5dcd7c7e559b9e97e62941d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b18b5bf0d002d7bdade7ad5525e4d4b13ffe1ba5dcd7c7e559b9e97e62941d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf1491d987baf288298135e9b0e615a7f46b976a8db8c8745b3b109b616bf597"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d96ecfe91c1296f1193ba2a4ba6f00387211d8022b9012ced647a34a29cf8247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53daa2ce0d6d4bafcc87053ca4af2d775d7eb54b6d4be3a3f19f42ba2e65e51b"
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
