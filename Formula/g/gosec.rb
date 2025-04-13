class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/refs/tags/v2.22.3.tar.gz"
  sha256 "f9b9ac7e82e8bc66ea340d161ce4034575174dd8fd9688e0cde089f2f4e8b31d"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "363a2b962e17892d4673747d460a4a5a977ebf26f79d6a1646069db58ce082c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "363a2b962e17892d4673747d460a4a5a977ebf26f79d6a1646069db58ce082c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "363a2b962e17892d4673747d460a4a5a977ebf26f79d6a1646069db58ce082c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a466435b0ffcbecc32e01e5bf211f1a60d84da89c16b0a7c3d18cc51c1308d9"
    sha256 cellar: :any_skip_relocation, ventura:       "5a466435b0ffcbecc32e01e5bf211f1a60d84da89c16b0a7c3d18cc51c1308d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a3c391451f47ac8e992befdcc754908bafadf94db7987df80b027bbf7319738"
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
