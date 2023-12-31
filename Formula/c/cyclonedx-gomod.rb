class CyclonedxGomod < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Go modules"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-gomod/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "b1e817d5adfc9f6c75b267c5254d5996fb3fab24f0accb125a95fe18c8952cc7"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-gomod.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e402fd020a82d1d7251508466e69e22ebfc82ca5d19064fb0352463d8fbabc4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "119ae6e429783ff6927ecd4702424caf3e1ef42e124ccbd350737cde12e3de0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b74b4a212ae81a1cc2ba7854cb11dbd1894dd5094a0dd28e22aa0dc4ed23a43f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e63e02fdf8fbee2aa6dc15ec07ea794b33554a25f3336dfbc4f32c2a2b76c1fe"
    sha256 cellar: :any_skip_relocation, ventura:        "dff8504e8327f5173974c280bba8074532522b6e3dc62fc60cf7df6bc8214be7"
    sha256 cellar: :any_skip_relocation, monterey:       "c634b38d5761d1e87256696986ab82afe13af108195d757214fb687cd3c8bb14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e377cb66e98e5f730d405203993039a5e672884d736d00f11fb9d54172a4e79d"
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
