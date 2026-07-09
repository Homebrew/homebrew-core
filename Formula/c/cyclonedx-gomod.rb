class CyclonedxGomod < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Go modules"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-gomod.git",
      tag:      "v1.10.0",
      revision: "ba940a6cad4202a4a6d2f9aeef33463c0011ff5f"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-gomod.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8c772c3ecfbe31b2cdce31b6cc1a291d4f15c81a9161b8435446f0a4f475e71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8c772c3ecfbe31b2cdce31b6cc1a291d4f15c81a9161b8435446f0a4f475e71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8c772c3ecfbe31b2cdce31b6cc1a291d4f15c81a9161b8435446f0a4f475e71"
    sha256 cellar: :any_skip_relocation, sonoma:        "25ccaedda49b499c01d12508cbcde51d2fe36eccb484fed41b98bdd0b3cd2cdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e6c2bcb322ba197f018acb5db58ffe6a27c944a00b3d0ff87cb0d81ff7829be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d82bd5cff3ef13fac8645a62c87d96837c54a863d7e9b9b5efdc15def0335f3"
  end

  depends_on "go" => [:build, :test]

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cyclonedx-gomod"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cyclonedx-gomod version")

    (testpath/"go.mod").write <<~GOMOD
      module github.com/Homebrew/brew-test

      go 1.21
    GOMOD

    (testpath/"main.go").write <<~GO
      package main

      import (
        "fmt"
        "time"
      )

      func main() {
        fmt.Println("testing cyclonedx-gomod")
      }
    GO

    output = shell_output("#{bin}/cyclonedx-gomod mod 2>&1")
    assert_match "failed to determine version of main module", output
    assert_match " <name>github.com/Homebrew/brew-test</name>", output
  end
end
