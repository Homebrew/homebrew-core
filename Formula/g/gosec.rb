class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.17.0.tar.gz"
  sha256 "5826ccb9310f9327ed2e010617a4742c1b12d28c199d1fd256f78606cbfc3c9a"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "310ebe82bcc35f9c95c1df3c3758b2c5bfbd6cca31b94bff74fc896caf996641"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca07012d412c71f5c6101602a3e8f184d1832d878e29061e8333b26df095b9e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "401fc3f79744541158c7e1d37f8b27dae97f85e0c292d60e40efd8bbe3ae6d2e"
    sha256 cellar: :any_skip_relocation, ventura:        "67d1543d2d4fb348f293e902d09b4d32080717ae92e5e0161ea29d332d499160"
    sha256 cellar: :any_skip_relocation, monterey:       "0967525aa0a4abd7435ee6aaac896823aec756d04fc141328da047256aa3f358"
    sha256 cellar: :any_skip_relocation, big_sur:        "4de02561ba69a1fab705034e76d8b77143144b9313babe9ec546654855e36dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df127b801c72ae2388bdb7a6a5b16a00e828bc8c02952cfaa0ff4b9ad732c22d"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/gosec"
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
