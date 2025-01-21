class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "da1a7f3224cf874325814dd198eaa42897143fc871226a04944583cb121a15c9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0c40fec06a95ecdd66dd1fe57b32c2bba8eff75b47d93450185495307313dde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0c40fec06a95ecdd66dd1fe57b32c2bba8eff75b47d93450185495307313dde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0c40fec06a95ecdd66dd1fe57b32c2bba8eff75b47d93450185495307313dde"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c0b6b71f712a526b08d5454b56ed3df896e585a98fc564f6380c25501729bb4"
    sha256 cellar: :any_skip_relocation, ventura:       "5c0b6b71f712a526b08d5454b56ed3df896e585a98fc564f6380c25501729bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b81782bbd9ea51aa7469409a35d6b9641f52f2ba492bdde3caa760673d1ecbd"
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
