class Goda < Formula
  desc "Go dependency analysis toolkit"
  homepage "https://github.com/loov/goda"
  url "https://github.com/loov/goda/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "ebaaea5f71363ee175d8f10591da199e3a7feaa3a96c18ddfada8dd9dec04058"
  license "MIT"
  head "https://github.com/loov/goda.git", branch: "main"

  # goda runs `go list` to load the packages it analyses
  depends_on "go" => [:build, :test]

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module example.com/app
    GOMOD
    (testpath/"main.go").write <<~GO
      package main

      import "example.com/app/greeting"

      func main() {
        greeting.Greet()
      }
    GO
    (testpath/"greeting/greeting.go").write <<~GO
      package greeting

      func Greet() {
        println("hello")
      }
    GO

    output = shell_output("#{bin}/goda graph -type edges ./...").chomp
    assert_equal "example.com/app example.com/app/greeting", output
  end
end
