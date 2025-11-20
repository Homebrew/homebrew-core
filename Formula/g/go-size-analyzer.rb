class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "ca1b8d4c18233f257e99454538ea08c496427dfbfeae8632f9c1ea02765274fc"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78db84054a2f5547cd9447c34ef3ec776c1cfc3b7eaa2dab8b269acb3674daa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf9eef846aabe2789dbf476d5d46d1f8a5422cb60de60b0fefe26c7f505a7975"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41e516c0c288cfedc077106ca7a09002441e495796d797d527937f24bcf087b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "537c9ada536b51c3e4ade7c1064e90f6ec9e396670586212a1532096e84ff4eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "886d8a1375f375696a74a8c1f30731ae6fb55a5671cd6f6d79cf163639e36e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "453467e5fc2a0c10d0d96127fc1dc10821ea25649e1196ecd28ddf8083c86bdc"
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
