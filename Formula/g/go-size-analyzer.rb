class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "36c97dc401227f066a8dc3be8170efa84741ef818c1bfd945d0ab3d0388902be"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a31e0817f2616d04e818ebad9ed7f04262a876b39736c14a3dad003fbc42a2b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "730f5d422602ac40e738a816665336e4b3662f3356ca594cf392e581f3eb6851"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d2eb02ac155205f856588d11dec070f39ff3b27df47c1a3578990d771c35571"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ea262f37b7dda6e33b266108aba541840ab5317e2787a7ff72559f30d19a68f"
    sha256 cellar: :any_skip_relocation, ventura:        "259a9b0026109ab83bf5bf0e55a9213abd7218ec4af7938ce224634fecb5fff5"
    sha256 cellar: :any_skip_relocation, monterey:       "81265b96a88ba09d7d1235b50aeab2212945eee10c8bb8f85c58570c703e1b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "026dd35c3bcdbc6009607e56cc3bf3af98a7f195cf2b3eebb9b8f85fa87ca281"
  end

  depends_on "go" => [:build, :test]
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir", "ui", "install"
    system "pnpm", "--dir", "ui", "build:ui"

    mv "ui/dist/webui/index.html", "internal/webui/index.html"

    ldflags = %W[
      -s -w
      -X github.com/Zxilly/go-size-analyzer.version=#{version}
      -X github.com/Zxilly/go-size-analyzer.buildDate=#{Time.now.iso8601}
      -X github.com/Zxilly/go-size-analyzer.dirtyBuild=false
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"gsa"), "-tags", "embed", "./cmd/gsa"
  end

  test do
    assert_includes shell_output("#{bin}/gsa --version"), version

    assert_includes shell_output("#{bin}/gsa invalid", 1), "Usage"

    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        fmt.Println("Hello, World")
      }
    EOS

    system "go", "build", "-o", testpath/"hello", testpath/"hello.go"

    output = shell_output("#{bin}/gsa #{testpath}/hello 2>&1")

    assert_includes output, "runtime"
    assert_includes output, "main"
  end
end
