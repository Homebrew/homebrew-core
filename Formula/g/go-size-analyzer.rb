class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "ed2e47600a1f83a625c06e4845472bfa7d0b6a961f105eb871e64c49c307d691"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94ec3bbd969b98083702b33c218b55ee5003276339150cfe93ee4905f3c843ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed2ea84e890876a09cf82e7f4a0c8bd09a3253cc779c05d572c5da83e002b3db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77b8e296b7521797b2f8e579a9d37116770b7fc18f6c8943edb25bb6964670c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbbfa258e68f7dec066efc4ca8e496a8eea7a73b9b2f231b5fda329c420b7f53"
    sha256 cellar: :any_skip_relocation, ventura:        "b3e35a814f16ec9ca417f26a6c9884dbaa83c5a2c4bbadddd238a69de63e6212"
    sha256 cellar: :any_skip_relocation, monterey:       "f577bcaf1b4030aeff8ff7a3bdaedb25101cd70ccfbfc85a5f7fdf3f281e263c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31e4c72160e75a054dd927739935702aa704b1a2b38112002c65a07bc1da46ff"
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
