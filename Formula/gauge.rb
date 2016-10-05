require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "http://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.6.1.tar.gz"
  sha256 "c5b0630611fe56ea98c018d03b4bb91713f0b891de0fa70e58af75bdddaaa435"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c897f59e5bfb1fac00b8aa0bafcb17362ec9ff592775c487fb006b6ec2645092" => :sierra
    sha256 "8a89b6d685890418d81b176b6ab5993ebbf299282e598f328d0f960ef5bf8b5d" => :el_capitan
    sha256 "3bc49428a78b72b602b839dcec1de5b6e8c493406d162128c25190f8f5020d55" => :yosemite
    sha256 "5af574faba350f2725c25c2fdcb992918ee88f67d0ad437e02f3b8ebb48c9302" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/getgauge/gauge_screenshot" do
    url "https://github.com/getgauge/gauge_screenshot.git",
        :revision => "d04c2acc873b408211df8408f0217d4eafd327fe"
  end

  def install
    ENV["GOPATH"] = buildpath

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
