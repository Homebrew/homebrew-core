class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "11fc5678f7d1d838b4dd38032baf32cd244d029dbe6a4a3e7d88a5e7ccdaf4f0"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "339969e5c8be49d8d644c3344eaa8c69ea83d80ac13b67bfb4229c64e8928db4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e814e3e23711563653150bfb3d4245e78650c7610731558d56f74cb69359715"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2809402175a076fa83fc251e2655a1b1e8485435a5a81ae5f6c47cfe3d87376c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3e076fc31da44da9d6a2d14dcc78cbe38b38ebdddbaf06c03474a12d8f9ee13"
    sha256 cellar: :any_skip_relocation, ventura:        "87d995cdbcefec40769bc92e684b566d620f24545b5c19c1d3e89b26498ec7c0"
    sha256 cellar: :any_skip_relocation, monterey:       "fbd9611c2e38eacb5de157dfe70e2ade52450bd83791abc6cbb363d8d8fb987a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7677c8a27ead3d06d5f92a51840f01bc448e02dd8d36fffa09f0525995b97d5"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/govulncheck"
  end

  test do
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      (testpath/"brewtest/main.go").write <<~EOS
        package main

        func main() {}
      EOS

      output = shell_output("#{bin}/govulncheck ./...")
      assert_match "No vulnerabilities found.", output
    end
  end
end
