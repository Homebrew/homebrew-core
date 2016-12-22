require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "http://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.7.0.tar.gz"
  sha256 "959ad3feea738d107e8840804b8faf82d1c1242db8beb1f746e21c76d7277f09"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "18b096f6e6e61a0cc96f715bff28936dd02dce9b0e597232a10f450a74ba20db" => :sierra
    sha256 "df8b41dffa4bf175d89d9729dc6fd908764e3bdeaf40accbb13d6d4e848710de" => :el_capitan
    sha256 "eee72ff60ec5335740eb82620dcf8c44dda195de182a89d40c3f924b5d3c6064" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/getgauge/gauge_screenshot" do
    url "https://github.com/getgauge/gauge_screenshot.git",
        :revision => "d04c2acc873b408211df8408f0217d4eafd327fe"
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
    assert_match version.to_s, shell_output("#{bin}/gauge -v")
  end
end
