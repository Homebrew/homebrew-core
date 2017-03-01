require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "http://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.8.1.tar.gz"
  sha256 "2eb6f358cecfa30b8d210aeb3814099bf7fd5f9f88486827e1fc224a5ec65f5b"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "ccaa3021a301fbe7fee1ec991e1215d5ff6865b358a1c668db5b334ed4b0bc08" => :sierra
    sha256 "d39c1df161f871c3cff8261aca33b6f588fba581afaa8be7202cb712801ac293" => :el_capitan
    sha256 "6f5d0b52104472e34aaa230dcc6921d39b3645ad65104744066efd7456e2cb40" => :yosemite
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
