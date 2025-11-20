class GoRice < Formula
  desc "Easily embed resources like HTML, JS, CSS, images, and templates in Go"
  homepage "https://github.com/GeertJohan/go.rice"
  url "https://github.com/GeertJohan/go.rice/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "dda8be9c9c594e164e664479001e7113d0f6571b3fc93253ef132096540f0673"
  license "BSD-2-Clause"
  head "https://github.com/GeertJohan/go.rice.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d678a810a2ad8a38e94feac1e95217927c75433f74bd58460146080c6fe9fca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d46108d4a8f53e1f8e3d4837ca941af6f3c866b247ff7c58d3bf8b65d34c43fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d46108d4a8f53e1f8e3d4837ca941af6f3c866b247ff7c58d3bf8b65d34c43fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d46108d4a8f53e1f8e3d4837ca941af6f3c866b247ff7c58d3bf8b65d34c43fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "52269f53fda001ba801a35a19c774755f8b183f3bf9d99474d852945b915e1dd"
    sha256 cellar: :any_skip_relocation, ventura:       "52269f53fda001ba801a35a19c774755f8b183f3bf9d99474d852945b915e1dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49d002fe74359b8e0f97bc5a488b21a32d7844f4b89e02845817f9bea5b3c289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acfb2a6c644ea76394bae1d3cb7607ad96ba33c478a0864e844373738d36c27a"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = "-s -w -X main.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"rice"), "./rice"
  end

  test do
    (testpath/"testproject").mkpath
    cd "testproject" do
      (testpath/"testproject/main.go").write <<~EOS
        package main

        import (
          "fmt"
          rice "github.com/GeertJohan/go.rice"
        )

        func main() {
          box := rice.MustFindBox("templates")
          str, err := box.String("test.txt")
          if err != nil {
            panic(err)
          }
          fmt.Print(str)
        }
      EOS

      (testpath/"testproject/templates").mkpath
      (testpath/"testproject/templates/test.txt").write "Hello, rice!"

      # Initialize go module and get go.rice dependency
      system "go", "mod", "init", "testproject"
      system "go", "mod", "tidy"

      # Use go-rice to embed the resources
      system bin/"rice", "embed-go"

      system "go", "build", "-o", "testbin"
      assert_match "Hello, rice!", shell_output("./testbin")
    end
  end
end
