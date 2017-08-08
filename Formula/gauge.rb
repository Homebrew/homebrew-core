require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.9.1.tar.gz"
  sha256 "659cd9679fa258ec142cf80ed92282c41aac44152f1193fa804bf00550e64e3a"
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
        :revision => "f16bcf089e263db525a255c9f9621ca0270ff1d3"
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
