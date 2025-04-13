class Cxgo < Formula
  desc "Transpiling C to Go"
  homepage "https://github.com/gotranspile/cxgo"
  url "https://github.com/gotranspile/cxgo/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "942393dc381dcf47724c93b5d6c4cd7695c0000628ecb7f30c5b99be4676ae83"
  license "MIT"
  head "https://github.com/gotranspile/cxgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebcf34c360a23231c3a1a78a54ad1904ba3cbd3e7f2938844247bf0324b02639"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebcf34c360a23231c3a1a78a54ad1904ba3cbd3e7f2938844247bf0324b02639"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebcf34c360a23231c3a1a78a54ad1904ba3cbd3e7f2938844247bf0324b02639"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce0073283d4a255dd5ba29fc637074fa24d59266c50826512b2217c8591e7427"
    sha256 cellar: :any_skip_relocation, ventura:       "ce0073283d4a255dd5ba29fc637074fa24d59266c50826512b2217c8591e7427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9cd5c2c79e9d44ec6bcb1dc71849d89e7c9f415b5f3abd4b757c31992bca295"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/cxgo"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("Hello, World!");
        return 0;
      }
    C

    expected = <<~GO
      package main

      import (
      \t"github.com/gotranspile/cxgo/runtime/stdio"
      \t"os"
      )

      func main() {
      \tstdio.Printf("Hello, World!")
      \tos.Exit(0)
      }
    GO

    system bin/"cxgo", "file", testpath/"test.c"
    assert_equal expected, (testpath/"test.go").read

    assert_match version.to_s, shell_output("#{bin}/cxgo version")
  end
end
