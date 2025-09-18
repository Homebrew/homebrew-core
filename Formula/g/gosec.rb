class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.22.8.tar.gz"
  sha256 "0732251f99fe85b621dfa0caddfc232d98d17bec849d26dd276df399cc8dce5e"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd42330abd536acaf7cafe60d574a458f7ef4b712a29a72797cefb9c8ea976c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83e54edb6839c304ad6f9fd5663317a62f2c1c8b7bc422efaf0992ace981684b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83e54edb6839c304ad6f9fd5663317a62f2c1c8b7bc422efaf0992ace981684b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83e54edb6839c304ad6f9fd5663317a62f2c1c8b7bc422efaf0992ace981684b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fa1d6121f56cc42245cbd55ee21f10af2b27015b4a21a3742c1cc24583d04da"
    sha256 cellar: :any_skip_relocation, ventura:       "3fa1d6121f56cc42245cbd55ee21f10af2b27015b4a21a3742c1cc24583d04da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f5743c5f7266252ab9faa72c4b981ad843bb1169bb8d96f59e5c84dbf1ab7bc"
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
