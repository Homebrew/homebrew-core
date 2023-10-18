class CyclonedxGomod < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Go modules"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-gomod/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "49644b3cb828e8f7a423d731706eb4a2ba9fb3f95e920ac95b08bdb4be0ffc59"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-gomod.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4f456068c2aaafdb81082c77bae6e450b0766d5ddfb6033406b651ed8c45a29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ead5d1f301ef74d2d135dcc68eba990f228426435a1ea62f14635fc5ad8f19a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a15b0fd0f579a3bd5d4b074f6563b7c544d366153603540e933da42a1259d3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9b410a4258782da414eced117bbd9447122d81a55a9ede3bfa8ff2b4bd1000c"
    sha256 cellar: :any_skip_relocation, sonoma:         "707081b91b279a8c7d0eaef47114ec2d7caa17bef20c73a75c4913f3838ccfc6"
    sha256 cellar: :any_skip_relocation, ventura:        "6f711742bd5f671f1d1e8619e9ec9f5f6a9ead5a66e59c98ddf72aab2fe76be9"
    sha256 cellar: :any_skip_relocation, monterey:       "eccf0d761da89f2048c4e941f3e684bb5e72f61ffde3519ac648c73607e6b60f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d73db47cd8c6cfacea3bdfc7e84ad2a1c5d13d0652be7da9804929aa6ed56ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba7361b77e42d7e047800e0f31c880b74e8f0e59236469ea1ba3c790eceee316"
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
