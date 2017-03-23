require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.8.2.tar.gz"
  sha256 "7a5ccfaa5d6358da80f6e1895ef285df38e780e838eecf19a380a854326d7fa1"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "55bfc060a8e4e8ef2ae2cb1032c3b7fe3befb8118cf314cefd766314dc077c8c" => :sierra
    sha256 "aba449c2bd51de2f269223de12262d1934eb522b5c8660f8c94a01a06360f6d3" => :el_capitan
    sha256 "f9e961353509891c66e3f598969449f0b7a07ea0360341ec994a9b071b2e9b61" => :yosemite
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
