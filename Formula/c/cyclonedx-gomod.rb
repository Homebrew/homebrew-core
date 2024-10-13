class CyclonedxGomod < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Go modules"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-gomod/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "6493b7235755de5df076bc160594acd32846348df7d04b5c3201bcf881cb6b50"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-gomod.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f810a10083102d9b50998410a1e17903afd9176b7915565523c644f529e88025"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f810a10083102d9b50998410a1e17903afd9176b7915565523c644f529e88025"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f810a10083102d9b50998410a1e17903afd9176b7915565523c644f529e88025"
    sha256 cellar: :any_skip_relocation, sonoma:        "de6f563653289ff2361a1109f75fbbb204010c7227c2e821fbce6c9666afce08"
    sha256 cellar: :any_skip_relocation, ventura:       "de6f563653289ff2361a1109f75fbbb204010c7227c2e821fbce6c9666afce08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cee249ccc42e249bbcd8364b25c9c3d8521c50a9f684132b028cfdf2a0a8444"
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
