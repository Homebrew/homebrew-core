class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "3929466820ceeb9ee6e2f44967f4c86f3259d331192a67be5c838c448c7921d4"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71ccd318efdec88f99b582e308d716420fe64f93c28954458da8fceab99c3870"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71ccd318efdec88f99b582e308d716420fe64f93c28954458da8fceab99c3870"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71ccd318efdec88f99b582e308d716420fe64f93c28954458da8fceab99c3870"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a5498584c52af1c8bf5c075acf546ae32f0141a45d4049ff32b4a3f1c0fd3a4"
    sha256 cellar: :any_skip_relocation, ventura:       "1a5498584c52af1c8bf5c075acf546ae32f0141a45d4049ff32b4a3f1c0fd3a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e3d6d5669d73ca4f32446fd63f4f5e36b0f4f42fe58f8d419065feeb435dda1"
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
