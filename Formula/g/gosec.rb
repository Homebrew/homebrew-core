class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "c4194879c05e86c8a0d15a29b420f51e2db84a48f746171186110baa05c51c56"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e7a70a1a5d9514633cfa18faf64a3c4cca69ad6f9f5840a8758c3145e5d2986"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e7a70a1a5d9514633cfa18faf64a3c4cca69ad6f9f5840a8758c3145e5d2986"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e7a70a1a5d9514633cfa18faf64a3c4cca69ad6f9f5840a8758c3145e5d2986"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9a7792233958c9f6d1824d03836b5bd8f2f3867302ee6d3f1c57dbb6e4c73b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a32178c333f4b38f1d7c87a00e16676fb1a0fb1f705629a42baa2bd2908c1ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d114524c60ba295833966f50d393037bb69bffa4805e5ee306c11781aa31cec4"
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
