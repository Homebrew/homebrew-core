class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "ff14cedf8e475fd4fcebbd955dee408e91e8753827e3c49404be26bd43a8dd22"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4da41aa716cfc5d6eaed59bf2e493d34abef25cb0c03675673814d79a8f29a98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d88340042f2896e0b615cc3c57d7fe851c1c12f5a716778860ffc11a9bfad2f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3dc86b1901a29153f024a77ffc4a881ae744a1bad9c0493174596975780c25d"
    sha256 cellar: :any_skip_relocation, sonoma:        "34a9cad8228d6fbbf79e8a6a481b18ba2ee09f705ebd9153dbfab17c5422bcc8"
    sha256 cellar: :any_skip_relocation, ventura:       "481f1630a562c723f6d53f5eb0e4d0fec670ba8dfe2ac62dd3b08acad4b03dcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d936214d9ff34693f3c1883dcf9047c2f05ac0f444b17976cd5334ea6b3514bf"
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
