class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.18.1.tar.gz"
  sha256 "13c10fae4f959bc56c7e7ebabe87874b8e08772c1fe0b3741a10abf27168a8e7"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fe6708959e682093d93e2613b6d1b03d09aece212f6076d8286fa658bf39923"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05f9bcf5fc8d0f9be44f845f4d05022f75db0441240bc3b74481897ae85f1040"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2240d5b0fcfa0a91771e8ad1e5b77fe96b5b710bda15c035eb9e52ea6c7c6bcb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2f3df3a095556feb854897b9a08c224ac4c4214c20ef20468851207c5c38153"
    sha256 cellar: :any_skip_relocation, ventura:        "399316842bae3f586de074752fb6fb65ecf3f11c0af96ca5800ccfb552988a2b"
    sha256 cellar: :any_skip_relocation, monterey:       "e54f539b4aa00eb00a3fb6f89c968541f2d9350102b3bcdd1ab34db90e38b3e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29d88aad2e70ea174350865aef28a011417e162b11dd3ce0b698759d97fac0fb"
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
