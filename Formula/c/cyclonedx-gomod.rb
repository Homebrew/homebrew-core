class CyclonedxGomod < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Go modules"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-gomod.git",
      tag:      "v1.12.0",
      revision: "07257d5b9cbd2a3d4338a880c0ca50081e1ac445"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-gomod.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bebe56e8e2a7d80c8df3b178aa9738603e09c0bce0db2930956bb6967d851f00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bebe56e8e2a7d80c8df3b178aa9738603e09c0bce0db2930956bb6967d851f00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bebe56e8e2a7d80c8df3b178aa9738603e09c0bce0db2930956bb6967d851f00"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec71729b3cfd701f685750b625d58ee649d74faf7dabb150c2e10470de536093"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b249e6395e54b8ab5f706c867a2b913266b512de02d7c83971259b0496fe7cd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88a6a9fe3f35772910e96766438479b135b8cda7d2f2d842050047864fb50122"
  end

  depends_on "go" => [:build, :test]

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args, "./cmd/cyclonedx-gomod"
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
