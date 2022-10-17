class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.14.0.tar.gz"
  sha256 "9ad3fe3106d33b638bf1212e96a7770ab6abb3877382e7bf2d98fecf09deef1f"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21904cafc7249820f25e76d3c6f3c0424dbd2aa69af5c38cee6e41c7348e70e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e69596971527988f73d60a1a00de4eebd44cf8fb96b98b0d2dbb0763ea7af3b1"
    sha256 cellar: :any_skip_relocation, monterey:       "6e6edcd49a0d7b2652551079b9a1c7a8e1e3f5d6a32dca27193db3ecd698d5a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "94b5ddb66586ddd7547bb436105aa2403e1eeb217334e7ab8886401e05b6d426"
    sha256 cellar: :any_skip_relocation, catalina:       "93c2c1ef6fca6f65e7cc43ba767a4c9139f79ec7fc40a5e32a6522e78a2fdd88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f9eb58cd6032f2db388edabb043a4f18927f3e458c751e3422d7d907963d852"
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
