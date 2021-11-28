class Packr < Formula
  desc "Easy way to embed static files into Go binaries"
  homepage "https://github.com/gobuffalo/packr"
  url "https://github.com/gobuffalo/packr/archive/v2.8.3.tar.gz"
  sha256 "67352bb3a73f6b183d94dd94f1b5be648db6311caa11dcfd8756193ebc0e2db9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17f7cbbcb3bec0a72bda849bc4aaab8f0cce5ad2ff00eacca19c7c5f23c2d8ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "795ec96787f9d2f6b53e074ad3cb13d131672e42dd4abd7f09f69be56f0a03d5"
    sha256 cellar: :any_skip_relocation, monterey:       "71f0dfcdb4c44dd96d702f6a1244f633ff391ffe6b6626a58f006e418b2a8854"
    sha256 cellar: :any_skip_relocation, big_sur:        "006868e5cf2c7e3cb2de845fd77be15d5b5c5fcc4c8a444ff69c90b89f507852"
    sha256 cellar: :any_skip_relocation, catalina:       "ea3edf2b50873a10f88e2356706949fd99882cf16f03f789cf9861a3af8676e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd1a47213ff76dce87c982588748502fa04fde7e82392e72cc0f6bd10efd2f14"
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
