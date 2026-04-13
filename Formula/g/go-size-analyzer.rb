class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "5dda9db2e1a87f2216e52daef04f879f396cbea8deb306f3e9b2b8ae92dc05d7"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "845f67989d67650f17fbf675072df8c4ba58ea4f68066d810c04207bc7592f1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afac0280a56450238542c239d1b4842eaaa331d76c6adb0141c126b4e41c4602"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c3a486244fd0a256a24c1a59c7cf8956d7bed76480c8899e069398a841911bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c3806e1835886200419dd7b1e468999dcd9578621c754490da26c641a8c97ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bb172adff6e921c31431791487576cc625af29b5ad86397889bbe1b143ff64e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d552383c659085b1e028542e9e53afcfc669219f9eca16157f482bf85c9e7e7"
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
