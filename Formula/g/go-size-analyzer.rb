class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "160415a10eaa2c1151dda1e8913d5d1ccf912cd7c18e35a673b88ac72667e507"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "771414597db278af1c70c428d3ff47284e40abf81b00d1778000a395e1d0bf59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50df9029e6fb1fad9183d5c5abbb5dea12a9ad9aa003639eae3132f96487dbcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4c83b17fc9a100c8b9bb389a8d86804ecf64fd962d24d36b0963a0cda3d4c22"
    sha256 cellar: :any_skip_relocation, sonoma:        "be045e379f3bb7541361cf17372b57d125b57eefec76446691be0686a72eb41c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2243b30923f131b6a212dcda9f54207a92b3cf4cd5e4a0761ca3470c6881dc12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de27e7ca46898a57ea61a90a659c17620da1c42e84677f88656f089a444adce2"
  end

  depends_on "go" => [:build, :test]
  depends_on "node" => :build
  depends_on "pnpm" => :build

  conflicts_with "gwenhywfar", because: "both install `gsa` binaries"

  def install
    system "pnpm", "--dir", "ui", "install"
    system "pnpm", "--dir", "ui", "build:ui"

    mv "ui/dist/webui/index.html", "internal/webui/index.html"

    # Set experimental feature for go
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[
      -s -w
      -X github.com/Zxilly/go-size-analyzer.version=#{version}
      -X github.com/Zxilly/go-size-analyzer.buildDate=#{time.iso8601}
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
