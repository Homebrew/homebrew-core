require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "http://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.8.0.1.tar.gz"
  sha256 "40ce96c975220a4218bab25600d6db9f9b5a8387ee3f28b154504f8f150ba856"
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
