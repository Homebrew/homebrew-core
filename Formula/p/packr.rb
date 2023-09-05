class Packr < Formula
  desc "Easy way to embed static files into Go binaries"
  homepage "https://github.com/gobuffalo/packr"
  url "https://github.com/gobuffalo/packr/archive/v2.8.3.tar.gz"
  sha256 "67352bb3a73f6b183d94dd94f1b5be648db6311caa11dcfd8756193ebc0e2db9"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "012421ccb6766aa56682433e05e85b8c8b6afc1c2681edbc856a02c2fecc74d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7cf08f5bbb1612452c67526c02f0f9d48ca9837962c89ba6a60886280c61dc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da232cec4e97f9565bd16bb0e3e4d64abbd4699883a4c1b380217312674ad5a7"
    sha256 cellar: :any_skip_relocation, ventura:        "375adfa65193c1923987f2edabe0e145c98514eecabdf4b9868836ee1362e104"
    sha256 cellar: :any_skip_relocation, monterey:       "035174493dcdafadae9f1c38c8e651f9d2511f37df2eeb9e9634e02dc5791f9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ced81e9a80049d9f1c878cb7b5850c7d1fe61b93b9f1847e659180f9ed0c215"
    sha256 cellar: :any_skip_relocation, catalina:       "526c8d9706b0b3c7d9538fc85db542cc5fe1041ebc5a5d2df7f3e2c2fd93d67a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71f763effa24fad2ae09028ea1d87f351cf0425ca40f1c25b5ef974839088f62"
  end

  deprecate! date: "2022-11-27", because: :repo_archived

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args, "-o", bin/"packr2", "./packr2"

    generate_completions_from_executable(bin/"packr2", "completion", base_name: "packr2")
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
