class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.9.3.tar.gz"
  sha256 "3bb9e13da409b40e7982199418e7449560ee6c14d7e99581dd30c94c4c6f88de"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "549961642f91a13ddeecb54e42fc29082a2caded0899db94322b94cf65044b56" => :high_sierra
    sha256 "4ca860842b71c958face93d07452cae6ccc220ec50914123e7775b77e6b286f6" => :sierra
    sha256 "0e7d6e4108eab026d9fcd9905fce65c159146bdf903f516c5499a2b52ede18d2" => :el_capitan
    sha256 "15cfbf4804217e796de1d7508bdcd28b54130b69e5fa791ddef9eb04f243c770" => :yosemite
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
