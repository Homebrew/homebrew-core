class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "4fb7f0204b7e039f550d8938b714c5218d870694895585e0e19b2c0c4700e4c7"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "352f2980c007f9c79f353e705ae98b0e44e01f45a98eac76db47309e88255c83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "352f2980c007f9c79f353e705ae98b0e44e01f45a98eac76db47309e88255c83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "352f2980c007f9c79f353e705ae98b0e44e01f45a98eac76db47309e88255c83"
    sha256 cellar: :any_skip_relocation, sonoma:        "26063ddfcede65cca41cddf41d080f2d2db0d8e630165e8be4279aa3369ca2bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab5e2480ec1ca10b51934a8d56338c8d4d66b9d97411ab741d047a34d710f1fb"
    sha256 cellar: :any,                 x86_64_linux:  "8824a8408c2bb013a41a64c2764bb92645f472e023fc5fdaa8aaa97fbfde2443"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args, "./cmd/govulncheck"
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
