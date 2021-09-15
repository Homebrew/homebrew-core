class Packr < Formula
  desc "Easy way to embed static files into Go binaries"
  homepage "https://github.com/gobuffalo/packr"
  url "https://github.com/gobuffalo/packr/archive/v2.8.1.tar.gz"
  sha256 "648f8690e0349039300d3603708bd383f3568193ebaeb0760a87da8760dc7fa7"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "42248acc120a492d9732361a70d87760d9041c5156373243170437c464eea152"
    sha256 cellar: :any_skip_relocation, big_sur:       "972c88a953ad8a1932f644f7cccd5c4f0d3909983192ed58f263855f36a28ddf"
    sha256 cellar: :any_skip_relocation, catalina:      "1cd8e38f05663594e4eb91e994da4f09865121814d4e04ebc414911550c0a02b"
    sha256 cellar: :any_skip_relocation, mojave:        "88a3cd339688b5ee3f30fe811691241f8daf6285ffaf6b772d216cfb4a961c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b1a3af58213c6725820c48a835ca209f5eef51d1d0e24e47e8a82fc1a21bb08"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args, "./packr"
    cd "v2" do
      system "go", "build", *std_go_args, "-o", bin/"packr2", "./packr2"
    end
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
