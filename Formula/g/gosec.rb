class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.22.10.tar.gz"
  sha256 "43f285d6bf40b1df9d72fc3e24658910ddd01cfe8bf03286980a129009e93af1"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52362f5d5a3ab833a26a002f1b84d2c356545ee9f299f3b6f5492c508e4db06c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52362f5d5a3ab833a26a002f1b84d2c356545ee9f299f3b6f5492c508e4db06c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52362f5d5a3ab833a26a002f1b84d2c356545ee9f299f3b6f5492c508e4db06c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9a9b6cfe98c207938f2ebba69bcac7bb8af3bae9f5905ca403d0339dcb3d8f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba5f25c5893bcd4d140a98e5733e30677aa90cdc71fc5f368aec130551d56df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef71d94640abaa605c83e978a0b4e282bc2fcaa3b4ff47957efb59a0496c6b44"
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
