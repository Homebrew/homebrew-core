class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://gsa.zxilly.dev/"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "66d4b05cc2bd09d10ff1e2c91d00fd1fe96ff30050699c0e57f6c0c0b9a4c2cb"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6655c1bce45f4d04f11fa3526c6b2f1ee0250aeeb2a9e0c50f0916c696b98c2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d66109261d10ef85c3a3a0497dac40c7b5037feab6d1cfaafa751fb4fa9a2051"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01ce94f0408ee5acc85195fc11a785ecd567423a62eb925766eb0ba8f5e55e88"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9bd216d1dad3540c53972e6a900f880a66734bb3af68ff5371e95d437c361d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d0b7d15e1987e25473089abacbb12e28fc2a7c42ee58e4cb6eca7d0256310c6"
    sha256 cellar: :any,                 x86_64_linux:  "6436688f8162299a030e4ca7501a2ad72aeb01f052823ea9eaab38221ad51f49"
  end

  depends_on "go" => [:build, :test]
  depends_on "node" => :build
  depends_on "pnpm@10" => :build # frozen build (default on CI) needs upstream changes for pnpm 11

  conflicts_with "gwenhywfar", because: "both install `gsa` binaries"

  def install
    # Prevent pnpm from downloading another copy due to `packageManager` feature
    odie "Switch to `pnpm with current`!" if deps.map(&:name).exclude?("pnpm@10")
    (buildpath/"ui/pnpm-workspace.yaml").write <<~YAML
      managePackageManagerVersions: false
    YAML

    system "pnpm", "--dir", "ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir", "ui", "build:ui"

    mv "ui/dist/webui/index.html", "internal/webui/index.html"

    # Set experimental feature for go
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[
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
