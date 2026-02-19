class Cxgo < Formula
  desc "Transpiling C to Go"
  homepage "https://github.com/gotranspile/cxgo"
  url "https://github.com/gotranspile/cxgo/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "942393dc381dcf47724c93b5d6c4cd7695c0000628ecb7f30c5b99be4676ae83"
  license "MIT"
  head "https://github.com/gotranspile/cxgo.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab751b7d073f7c78c4ecb82c6edadc57476cdec1ea3c521b53cc232d66ad72da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab751b7d073f7c78c4ecb82c6edadc57476cdec1ea3c521b53cc232d66ad72da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab751b7d073f7c78c4ecb82c6edadc57476cdec1ea3c521b53cc232d66ad72da"
    sha256 cellar: :any_skip_relocation, sonoma:        "f77ecb515a9c0b2a492156ca40f9b86596f37c655a62a7535a98e24fffede206"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88adc13241a6def00e580f577e3d1d7c5a6d89e6ca08f8093786a99c1a0bed1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eaee422179c374dbd0b2f525135398ec4135d37578272005971b8507950caec"
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
    generate_completions_from_executable(bin/"cxgo", shell_parameter_format: :cobra)
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
