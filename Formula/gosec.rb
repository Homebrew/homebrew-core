class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.14.0.tar.gz"
  sha256 "9ad3fe3106d33b638bf1212e96a7770ab6abb3877382e7bf2d98fecf09deef1f"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "591c852bbcd88a449437201a9e4d2bfa1c3c7154a1ec5bc032f644568428f2ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2eab7c34be69b98d5d99007df9732a22f472171a0bd63ac8d27f06edbb75396a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d714544adca04bd7f7e9169ff88ac2bb2dbabdec063573dff653816d6915f067"
    sha256 cellar: :any_skip_relocation, ventura:        "cdc2039f3153fb48533bd29faecb83095003afde4a8add7f3b623003c11a2cbf"
    sha256 cellar: :any_skip_relocation, monterey:       "928628df9881a812b1defc03416166a131b30fd0a6dd4db39dc21ccb4e84b6b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c54bd579517d84a03ce1cf0dcf5d3953ddce9f11620d67071f67a4604ba9f85"
    sha256 cellar: :any_skip_relocation, catalina:       "ae86679cda4bdcfde37da70d505aa693807ddac8ca9f698804398b760834d15b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69a61727e67de81502884b8bf25c185d09d0a8f442f0a9d074fc7835909b2e33"
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
