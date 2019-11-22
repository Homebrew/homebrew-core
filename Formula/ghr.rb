class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "https://tcnksm.github.io/ghr"
  url "https://github.com/tcnksm/ghr/archive/v0.13.0.tar.gz"
  sha256 "53933c6436187f573128903701ce74ac341793e892d3c2f57c822c0ce3c49e11"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8b18b88a8110aaece873467c0104615d341a8e0c62d08ce9cf302ea0d671bad" => :catalina
    sha256 "7890c5b66ae184b37fa958c49dbc83759eb392b1895c646f1ea7026ac0a3d266" => :mojave
    sha256 "4ddd6326018db9e44584c9d730999fbfa78dd075ebd9007cb24d026630e69006" => :high_sierra
    sha256 "3d96e05a7cc1bb89e910845db0f6ed80175f8f77c31adc0938a5716414296fad" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/tcnksm/ghr"
    dir.install Dir["*"]
    cd dir do
      # Avoid running `go get`
      inreplace "Makefile", "go get ${u} -d", ""

      system "make", "build"
      bin.install "bin/ghr" => "ghr"
      prefix.install_metafiles
    end
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_include "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end
