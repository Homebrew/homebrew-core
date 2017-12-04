class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.9.5.tar.gz"
  sha256 "630bac56d1f855eebefc43b6f9e8a43362aced8c2c0fe7095db9a3b3387fbf26"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "9cd8e6c287795fd1f88f50721b9eba34cc7b0aebdc0d839cfdab286eed3269c5" => :high_sierra
    sha256 "96ce1dc89a4ffe36298e439ce39c1d87a0d424b1a74eadcb6c0032f4e955d18a" => :sierra
    sha256 "9a08e27d04caf02735e8013070b4506c049064f99b1bab23022c6381b3603ff5" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec
    dir = buildpath/"src/github.com/getgauge/gauge"
    dir.install buildpath.children
    ln_s buildpath/"src", dir
    cd dir do
      system "godep", "restore"
      system "go", "run", "build/make.go"
      system "go", "run", "build/make.go", "--install", "--prefix", prefix
    end
  end

  test do
    assert_match version.to_s[0, 5], shell_output("#{bin}/gauge -v")
  end
end
