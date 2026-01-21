class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "4c8a7820564f462a953aaada38f212e0248464205315d6715cc98e274266ba53"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24267b7e559889a6f48a9a3c9bf9119a3cea19011610fd88b46e0c3ae49e8c00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96d3bd13d1ad650397bcc37211034e1726a49db1d7da0fd966a8c38a51f32019"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9eb872769f075ad001123bf756a4a503219b23cfc641ada7e48f472e2fefd38"
    sha256 cellar: :any_skip_relocation, sonoma:        "26323654595cfde162ed429663a0fa7339281b85501a2c0dbddf52fa808e5a63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62bf6aae89c97d81e2ed78697bb6053c17c19c6c40041efa364be57fa43655ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc3da0a70d03dd99ed8524c11639cba1116e29a30714a2551d4c271268b63583"
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
