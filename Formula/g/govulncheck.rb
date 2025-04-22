class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "da1a7f3224cf874325814dd198eaa42897143fc871226a04944583cb121a15c9"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab516a4d8e06b264e4056cc7b2559a6283d3b22837bd1f6fb0aa793ab26f86c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab516a4d8e06b264e4056cc7b2559a6283d3b22837bd1f6fb0aa793ab26f86c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab516a4d8e06b264e4056cc7b2559a6283d3b22837bd1f6fb0aa793ab26f86c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "543b6dac71b6b63135bd0ceefb1486ab3fdc7c105963403f933352acc08fb885"
    sha256 cellar: :any_skip_relocation, ventura:       "543b6dac71b6b63135bd0ceefb1486ab3fdc7c105963403f933352acc08fb885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8a7b7d79a6746784346ee9aaf519587f724a363cea87200c4c0b10ad04d316c"
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
