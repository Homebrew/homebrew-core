class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "92c9fe6300bb9b5aae3f26e1524da3410a490a133ce9b28f34c6dd6ca80fc13e"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc61d904346e7292f58b282e39dcc09bb1e2dedc0137be397325940261e6ff17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b10af81fba79230fcac43c2cf6ba7cb85bd599e82b362821a3a43339a983ef1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f80fb22d4c5c23de62e83f40d669e176ac7ca1fe30dc35c639779d8957c1060d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a19f578d7ef9e201dcb35d9c9afe17401752a71742553ed161cbdd1ac2ced541"
    sha256 cellar: :any_skip_relocation, ventura:       "13eeec6d0256075291da90e55a6b5cd8dca668b0e54bf5fef2714f243a2f95a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8a41ee4814d65acc66f09f46b6dc87e007eea038b7aeea1f551c0821d12d013"
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
