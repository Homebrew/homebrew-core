class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.18.0.tar.gz"
  sha256 "6b780dcd2270d5c95214c5e2c159b4eb86be5c5ec934bcbe583acb447597dce1"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43345c68f03d6fdb57f540eecbb29f8229924c1fc6e0c873f3fa0b25f4fa04ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "909a37ab9840d112dda1515498e6c53830cbc9759a1f6592e3292d14fc7f1039"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de18606cc583646d3b7d571cffcd64a0371d3564831e6c58b144623b7a52bfb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "36db34028e707409068b0e31a9a4b1188f6f8e04f699f9b74004b97a555fbf79"
    sha256 cellar: :any_skip_relocation, ventura:        "8d349c683f589fb0a8a7cce227be50e50771bde9b1481c0c3d93d4948708fa8d"
    sha256 cellar: :any_skip_relocation, monterey:       "5aa39f9671d6fdcdf6ebf013b7a27bc528dc2bcfbabf5e0c88ee62e762160d36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df3e68fa31217185b22f5a9de4eb07c319cbba5c538b318b979f847213302b1c"
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
