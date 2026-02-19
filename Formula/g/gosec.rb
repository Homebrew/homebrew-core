class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.23.0.tar.gz"
  sha256 "0f76298ac3b21302c6a75e68a5410495c3f70e8327e244575262799313d1ea88"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0279cd107e3a408c1be7f05ab21ee1f7b283c12c82642345ff705d7ce42b6c38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0279cd107e3a408c1be7f05ab21ee1f7b283c12c82642345ff705d7ce42b6c38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0279cd107e3a408c1be7f05ab21ee1f7b283c12c82642345ff705d7ce42b6c38"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd3d9679e5dcbc6dca07c6c2d8eeccc2715b36bd3f1d22900920264b44619d52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5106cffa28b94f1c81561fd7b5769028eb283c0c6d092273185ec7cc0e725bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77c39eace8e1301cf35d6d0338e7b707f0bfd80616e55bf4432ec91801bdd3a7"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitTag= -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gosec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gosec --version")

    (testpath/"test.go").write <<~GO
      package main

      import "fmt"

      func main() {
          username := "admin"
          var password = "f62e5bcda4fae4f82370da0c6f20697b8f8447ef"

          fmt.Println("Doing something with: ", username, password)
      }
    GO

    output = shell_output("#{bin}/gosec ./...", 1)
    assert_match "G101 (CWE-798)", output
    assert_match "Issues : \e[1;31m1\e[0m", output
  end
end
