class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "3b9ab52baf3239414a793428bfafa029eb5af38206dd021b14ed63329b1e59d0"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b80b6c9938b0c47315dc1344413b51a6882bc3b36434251426acb67f11da3e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0eee00a2e457de704fb2222bbe868501f0ef586cc63dec9fafc09fc826dcf37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bcce420e18096189807a5171eab22e9c3bf12d911960cd08bcf44523aeb5608"
    sha256 cellar: :any_skip_relocation, sonoma:         "0cc968f6bc877f3c413cb79b1e304667af011da835f2c1510fb94a880017fac4"
    sha256 cellar: :any_skip_relocation, ventura:        "898107baf4fd5626b7a0f866f81149b252a7114068b20701cc4b7dd16e2d5e8a"
    sha256 cellar: :any_skip_relocation, monterey:       "87fdf1aea55974ff742c8eefb86e7bdb33965744d8213429e783f1f87dfcc9f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41293a8d5d93f5249cfe2420547ea7ee2a663c135ec10783d9414c155c51f6ff"
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

    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        fmt.Println("Hello, World")
      }
    EOS

    system "go", "build", testpath/"hello.go"

    output = shell_output("#{bin}/gsa #{testpath}/hello 2>&1")
    assert_match "runtime", output
    assert_match "main", output
  end
end
