class Packr < Formula
  desc "Easy way to embed static files into Go binaries"
  homepage "https://github.com/gobuffalo/packr"
  url "https://github.com/gobuffalo/packr/archive/v2.8.3.tar.gz"
  sha256 "67352bb3a73f6b183d94dd94f1b5be648db6311caa11dcfd8756193ebc0e2db9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78402bd55fe8a3c1c2e354e1d0a394bfc62b2c223016f93ce671876cee786b9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d33f607b95795245e701beae7c7518065a20eff0123cf589a5492623f073f804"
    sha256 cellar: :any_skip_relocation, monterey:       "95d3bb5b313625de9988d49459df4f7937fc4b6b95c1edde704b6df3e4e76c80"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f8dfe789d79d2db26072577c7d304d12b65a88a36af73e8d188388487bf4ea6"
    sha256 cellar: :any_skip_relocation, catalina:       "1c9b6831e7d16b51c3489216c96a10200fc08fbfaff22f39e0d4a70ca12e7555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76c1441bae5ded86a2f6f032b5d69030bdddd94d1a9f10ae4d7a28050612c683"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args, "-o", bin/"packr2", "./packr2"
  end

  test do
    mkdir_p testpath/"templates/admin"

    (testpath/"templates/admin/index.html").write <<~EOS
      <!doctype html>
      <html lang="en">
      <head>
        <title>Example</title>
      </head>
      <body>
      </body>
      </html>
    EOS

    (testpath/"main.go").write <<~EOS
      package main

      import (
        "fmt"
        "log"

        "github.com/gobuffalo/packr/v2"
      )

      func main() {
        box := packr.New("myBox", "./templates")

        s, err := box.FindString("admin/index.html")
        if err != nil {
          log.Fatal(err)
        }

        fmt.Print(s)
      }
    EOS

    system "go", "mod", "init", "example"
    system "go", "mod", "edit", "-require=github.com/gobuffalo/packr/v2@v#{version}"
    system "go", "mod", "tidy"
    system "go", "mod", "download"
    system bin/"packr2"
    system "go", "build"
    system bin/"packr2", "clean"

    assert_equal File.read("templates/admin/index.html"), shell_output("./example")
  end
end
