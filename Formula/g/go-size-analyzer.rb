class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "55dfd6e1d80300028e0f47ba5cceaa1de74b0a8a110f1ebfbf1c8fadf6bcea7f"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a78b0f65bf07e9566252f9fbef347e4775cf75006d893a0a64ba7188bb6c9c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48dfbaca12d2d50efbde103f8ccb85ff392cd06a2b94ec9b68c0ec62c16eecf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d59d901904714e5ba86c5586281f880d2b8769a149a85498fff0e875577d6d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "972ad6a789e49a7e0579ae56218ba483ad2d997cfeded67dff34972e187faa33"
    sha256 cellar: :any_skip_relocation, ventura:       "132c06f44df8b11f6b259bc91ef5612a17268e3fd1ae217ed67df7c2c23c374d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06a29d8343e4aeeb3bd647d63bbe4f3105c18e1e52457dbde8172fda484d24c2"
  end

  depends_on "go" => [:build, :test]
  depends_on "node" => :build
  depends_on "pnpm" => :build

  conflicts_with "gwenhywfar", because: "both install `gsa` binaries"

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
    assert_match version.to_s, shell_output("#{bin}/gsa --version")
    assert_match "Usage", shell_output("#{bin}/gsa invalid 2>&1", 1)

    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
        fmt.Println("Hello, World")
      }
    GO

    system "go", "build", testpath/"hello.go"

    output = shell_output("#{bin}/gsa #{testpath}/hello 2>&1")
    assert_match "runtime", output
    assert_match "main", output
  end
end
