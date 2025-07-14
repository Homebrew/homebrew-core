class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.22.5.tar.gz"
  sha256 "a0cfe91b35e36c46214f1a761a149d938a9c2bcf8be3b14be335f53cc24cc1cd"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03b4374b3d02737e48732b1f2bcbd606462531be504772a17bad2d7193d35e57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03b4374b3d02737e48732b1f2bcbd606462531be504772a17bad2d7193d35e57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03b4374b3d02737e48732b1f2bcbd606462531be504772a17bad2d7193d35e57"
    sha256 cellar: :any_skip_relocation, sonoma:        "969ee2ef6ae5167810a95250c4c15c507e82a8cea4bc2d91ae80dfd5e2715c33"
    sha256 cellar: :any_skip_relocation, ventura:       "969ee2ef6ae5167810a95250c4c15c507e82a8cea4bc2d91ae80dfd5e2715c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd3d9c8cfc5d6a474c4dda306c9f18b9dca23cb6a72c9787d3ccdd128225d626"
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
