class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "57965af14e2579ea44928070aa04251ecbb1fb4e206c208b4aec6f803ca36b5a"
  license "BSD-3-Clause"
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0a4b7a5158abd956e0a1774d951bba2a05e15f72107607878f37ff160946103"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0a4b7a5158abd956e0a1774d951bba2a05e15f72107607878f37ff160946103"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0a4b7a5158abd956e0a1774d951bba2a05e15f72107607878f37ff160946103"
    sha256 cellar: :any_skip_relocation, sonoma:        "5438414b291356a0b9d6018356aaf8c2c7abbd4d9e2c17cc432d67e2487011f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6654070bc83ec92c6bc58370e9c59fa8db6d961a77d229165f5651701357fa9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d88ab8655a0301412d9987cf804097ec8023d904d2ef0a74e0bd2131bcd8904"
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
