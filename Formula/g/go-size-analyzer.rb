class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://gsa.zxilly.dev/"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "c33d0ff8c5c5fd37cb30d8d6a963fe07a20f13cfe4bf2cf3832af93f421eee11"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f28e1c237d7c97ca26ba22d5b45f630315409c6c6d02de8e3d2c7d57196b2f92"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ac03dff6f4e89ca85c90950aac44c447ce3268b2fa2a388fa616b0694db25e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d00339dfcd33e7511acab23cf2012518641c1d2641a78a414c8f51fb5b4aed7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b5322dccd71c4b79df238ee7ecbdcd3ed93af51c1d9a13a3f3213a948bf76bd1"
    sha256 cellar: :any,                 x86_64_linux:      "82500d52509d998e904d9d8307c9681d63c64d51a23722e4e9158a31f764e42d"
  end

  depends_on "go" => [:build, :test]
  depends_on "node" => :build
  depends_on "pnpm@10" => :build # frozen build (default on CI) needs upstream changes for pnpm 11

  conflicts_with "gwenhywfar", because: "both install `gsa` binaries"

  deny_network_access!

  def fetch
    # Prevent pnpm from downloading another copy due to `packageManager` feature
    odie "Switch to `pnpm with current`!" if deps.map(&:name).exclude?("pnpm@10")
    (buildpath/"ui/pnpm-workspace.yaml").write <<~YAML
      managePackageManagerVersions: false
    YAML

    system "pnpm", "--dir", "ui", "fetch"
    system "go", "mod", "download"
  end

  def install
    system "pnpm", "--offline", "--dir", "ui", "install", "--frozen-lockfile"
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
