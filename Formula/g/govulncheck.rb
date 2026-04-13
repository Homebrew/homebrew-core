class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "da1a7f3224cf874325814dd198eaa42897143fc871226a04944583cb121a15c9"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "825fddb026eb8f9a3770bcf7b09d2b9bef1329ad545dc53f1b51c3f0959cb0b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "825fddb026eb8f9a3770bcf7b09d2b9bef1329ad545dc53f1b51c3f0959cb0b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "825fddb026eb8f9a3770bcf7b09d2b9bef1329ad545dc53f1b51c3f0959cb0b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd9a00d101beeb2e61e291df0979e785eed99022a236a3f840cac2c7fe766253"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a162e34d183882c2985d473519ec69c765309dd5557bb6a02ca006009f05d6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ac969948b4479091b8f332a904c4cbcd146d2e29df0e2254264ee859da6d91b"
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
