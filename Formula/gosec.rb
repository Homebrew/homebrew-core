class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.9.1.tar.gz"
  sha256 "c0a1352b55f70a2926a1178ff9a2257d8ce8c0832776b386b4d6cdfbbd60b004"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e96cbfd827be9a9b6d0e1adb9caee8e3160be0d95c25baf6bf91f29ccdf9a1c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "dfd977f6bfff4c738f6ce0082bb7551d4b5763c64d8110ba3fa2d14fc3b49a11"
    sha256 cellar: :any_skip_relocation, catalina:      "7913019c62267e97f3c4bfad104b83ab94e718b6ec89dac921d6b7140e520b29"
    sha256 cellar: :any_skip_relocation, mojave:        "718f7c387a51ef6f32887a6c27a62acb4d4d1831b3c4e8bc7bd7b6edcbeedd66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afc27466cd8224c79a053eab34454826c00ff7b70dd7c1b75459f6e56fdd5b88"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=v#{version}", "./cmd/gosec"
  end

  test do
    (testpath/"test.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          username := "admin"
          var password = "f62e5bcda4fae4f82370da0c6f20697b8f8447ef"

          fmt.Println("Doing something with: ", username, password)
      }
    EOS

    output = shell_output("#{bin}/gosec ./...", 1)
    assert_match "G101 (CWE-798)", output
    assert_match "Issues : \e[1;31m1\e[0m", output
  end
end
