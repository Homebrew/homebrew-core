require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.8.5.tar.gz"
  sha256 "2f6384cfecfd40784c7c5a3280233ea5cf77f82d75c9eee8ebf3652d8a660dac"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "61297c5005d8d2af0b0a0c6e52161a2911f9c646d552a17a82dedd729e9608af" => :sierra
    sha256 "9933d6da1783b8d456af364705bc4fbd7b78161db5c539337e4b3f5b835fd0cd" => :el_capitan
    sha256 "61aaa2767ec4267036db8897bf1bf0521f50e209ffb5d72a069875f815abaedf" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/getgauge/gauge_screenshot" do
    url "https://github.com/getgauge/gauge_screenshot.git",
        :revision => "23dd83ae2eeed5be12edc9aa34bb34246cebe866"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    # Avoid executing `go get`
    inreplace "build/make.go", /\tgetGaugeScreenshot\(\)\n/, ""

    dir = buildpath/"src/github.com/getgauge/gauge"
    dir.install buildpath.children
    ln_s buildpath/"src", dir

    Language::Go.stage_deps resources, buildpath/"src"
    ln_s "gauge_screenshot", "src/github.com/getgauge/screenshot"

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
