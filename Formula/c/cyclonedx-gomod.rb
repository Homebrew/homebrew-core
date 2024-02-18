class CyclonedxGomod < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Go modules"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-gomod/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "1c364f76bd6706054804c3d5568e2480771e2b5149cfccd6b31c77a9b490ad75"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-gomod.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab59494754f6655df87e2f2084a6fcbeecda3916b622c2381652da7c8d74085d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf4a4576419a3f9b810beb3796860886d40225d7bece7e76a162807643ff0538"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5f98e2be518f481775333d84bcb6b8b829fa8fa60c99b8eb12c66d0ace63233"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e505e92b25ea7f88c64211e3aae1588ac4d14250da09331100667d5c01e9ab8"
    sha256 cellar: :any_skip_relocation, ventura:        "c086fb2adb33d314a6d3a37afbfec537ede059d3109bb81e2951624dccb0f68a"
    sha256 cellar: :any_skip_relocation, monterey:       "170a4749c7d63b4215a13b374400247e12c06c49105bd34c66b88baf0ea6d9ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d36ef9a04ab063871f7c875b0666d18848ad95f008dbba3974ea54a4c784049b"
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
