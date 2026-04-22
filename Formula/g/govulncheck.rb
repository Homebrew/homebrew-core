class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "f9477f4467198c4164fc7c25e61e974e2a0f791407a9b090862c5e760e1fc3ee"
  license "BSD-3-Clause"
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4beb56264d8e626d8f83ba4539d81a3d3ec538a58656982bbe5f11726b31c694"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4beb56264d8e626d8f83ba4539d81a3d3ec538a58656982bbe5f11726b31c694"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4beb56264d8e626d8f83ba4539d81a3d3ec538a58656982bbe5f11726b31c694"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2602032e55fe157ad8eeec3a4048c81f315d2d2e5be7589f54cdf1c35a6c2b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c67452a83ee85141cfce29094aff380cdb5e7182731c1de000b9c16026b001d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0f2884dae1af5a0a93cc39688308c048225aea150336e6f37d4b8274bbae5c7"
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
