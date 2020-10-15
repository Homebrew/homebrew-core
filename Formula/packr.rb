class Packr < Formula
  desc "Easy way to embed static files into Go binaries"
  homepage "https://github.com/gobuffalo/packr"
  url "https://github.com/gobuffalo/packr/archive/v2.8.0.tar.gz"
  sha256 "2cab1e8d60734af05d594346f8e4bffcef0ac2aea4895b08bd9f3c40fc24c639"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8561f6d5f99b51a6df9fb1df10f8f421daacf63a5548e043c0fbc970bf5f6dba" => :catalina
    sha256 "ee4c60e7fc20bd3323fa89d0ef296162e05435cbab809b6365b75cfbde6c6ddb" => :mojave
    sha256 "2317f06a9fe8d49069f0ed59eca5aac45d82caa5f45d88f7f3c1f60e679c8cd9" => :high_sierra
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args, "./packr"
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

        "github.com/gobuffalo/packr"
      )

      func main() {
        box := packr.NewBox("./templates")

        s, err := box.FindString("admin/index.html")
        if err != nil {
          log.Fatal(err)
        }

        fmt.Print(s)
      }
    EOS

    system "go", "mod", "init", "example"
    system bin/"packr"
    system "go", "build"
    system bin/"packr", "clean"

    assert_equal File.read("templates/admin/index.html"), shell_output("./example")
  end
end
