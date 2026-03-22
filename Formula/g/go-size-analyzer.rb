class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "0e1734c90e6ff1a45b079e4c4eb2c7bc1bfe9a85c9d9110133aeb39323f6ee36"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5c2d5d339814572a029402912e0bb9c5e17253c48e3e77b0b5348701b0e7bf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71edc87025ae31d1f2d557c19ca6913a392a6c4a7458d77f08ada7fde25397d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5461f4a227ae13f00760998523588e4ae7be00b38aca0f09a1210631ebf91ed2"
    sha256 cellar: :any_skip_relocation, sonoma:        "266d8181313ced42fa6f2ce1f3d0ce5823652be93bc418a35f376076428973cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "164f75d53bc81be92a23f26bb4a70b0445302a8192b80405c2d063ef1a40b81a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ecea403e82b3400d66983bb754863911c8605dc5e66464de6cbaf1dc6369afc"
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

    system "go", "build", *std_go_args(ldflags:, tags: "embed", output: bin/"gsa"), "./cmd/gsa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsa --version")

    (testpath/"hello.go").write <<~GO
      package main

      func main() {
        println("Hello, World")
      }
    GO

    system "go", "build", testpath/"hello.go"

    output = shell_output("#{bin}/gsa #{testpath}/hello 2>&1")
    assert_match "runtime", output
    assert_match "main", output
  end
end
