class CyclonedxGomod < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Go modules"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-gomod/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "4490e44e2478a3f8b62e568a530b604ace14bd12d26c0fb41656a24ffec566c7"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-gomod.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f3bdc7fcd931ac2cca24cc768c523fd1aaf378932c7619db84d027b381db9a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "265722bab2f4df44779e227d2a45ee302a98730f803ff0edbc35b4bd5d20f160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "265722bab2f4df44779e227d2a45ee302a98730f803ff0edbc35b4bd5d20f160"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "265722bab2f4df44779e227d2a45ee302a98730f803ff0edbc35b4bd5d20f160"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4aa6ed9b23eb79645acb210d928c754478c4b35c1883658e4db783eefaf61b6"
    sha256 cellar: :any_skip_relocation, ventura:       "f4aa6ed9b23eb79645acb210d928c754478c4b35c1883658e4db783eefaf61b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bfff00a31c04f53d5ec3cc06a9a86ae5313fb340a8728b4cebca137ef73a177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5fd68398150bd54eb229bffe89f2a83af73ab907b17df5f328fbeffd40753c9"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cyclonedx-gomod"
  end

  test do
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
