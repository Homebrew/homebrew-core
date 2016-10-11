require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "http://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.6.2.tar.gz"
  sha256 "1349c105ffeff9ddfb227f6b88c263eb069b2af768ac806a87d260a5c3390464"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "3aa0d0a2621ed6742cff4f1575432f511f734a6d7f93080ea6c6d5fa9f2c5412" => :sierra
    sha256 "0b5fa1edfbf86c2263df3a4b716fc914e261d077cbc99add429a7e582aecb788" => :el_capitan
    sha256 "3ad5bb700139d027aa05e3a766b44b9f15cc868fb6958b39eda3d3902fc48bd8" => :yosemite
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
