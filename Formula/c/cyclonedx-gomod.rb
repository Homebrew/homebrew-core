class CyclonedxGomod < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Go modules"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-gomod/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "87f5aa06c7095ddb4e67b549e43a961915384e1513329da87f8270edfaad1f05"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-gomod.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84c98a0eaf5f6ce84c89c5a20ab14fe6e8dc6d410747b0abcda7a080d3365d86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd4fbc1e3a87d663221a0489d5c5a2b291347399940aac387d4cd29c4cb1c4ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8027696149cdd3d21f2b0ce5f1855da24a76ac948324d83f9a888a8874d7c608"
    sha256 cellar: :any_skip_relocation, sonoma:         "f36ad96beeeec59f103ca4d1e31c01aed2fecee4ef43c1a6b16cb9b3f954a7ae"
    sha256 cellar: :any_skip_relocation, ventura:        "a6a6f07fadf31784652cbfc974f4b931357fd6a197ce29fb78be7bfee8072d04"
    sha256 cellar: :any_skip_relocation, monterey:       "87161982dffbd21ae4eb6000c54aa42cc92dc4e27c17ded8c027945c21bd6494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a511bf3cb2ce5ea71a91fbaadc93d1cb63faee6ecdacb00b0916a1071e844d6"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cyclonedx-gomod"
  end

  test do
    (testpath/"go.mod").write <<~EOS
      module github.com/Homebrew/brew-test

      go 1.21
    EOS

    (testpath/"main.go").write <<~EOS
      package main

      import (
        "fmt"
        "time"
      )

      func main() {
        fmt.Println("testing cyclonedx-gomod")
      }
    EOS

    output = shell_output("#{bin}/cyclonedx-gomod mod 2>&1")
    assert_match "failed to determine version of main module", output
    assert_match " <name>github.com/Homebrew/brew-test</name>", output
  end
end
