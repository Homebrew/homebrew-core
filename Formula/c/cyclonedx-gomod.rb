class CyclonedxGomod < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Go modules"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-gomod.git",
      tag:      "v1.11.0",
      revision: "016a6750ec5b892ed27c3030f635ea15d479ec26"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-gomod.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "709dcf93b0ce4f63f2dbe0ff70e7c9403bc248453eeacd4994daddaa45e9eb8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "709dcf93b0ce4f63f2dbe0ff70e7c9403bc248453eeacd4994daddaa45e9eb8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "709dcf93b0ce4f63f2dbe0ff70e7c9403bc248453eeacd4994daddaa45e9eb8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0f13aeaaf3201429fa437b4a7cfa195c0b38b9dbac2af64ba9a2006495bea71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43689e95dcc5462918678248cab87971c06bc2ee1df3ef35b6d4b79bddfe46c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "632e86241891ebbdb74b148994950e19c4777f6bd698f4a89dc7b67381ef8a6b"
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
