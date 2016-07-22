require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "http://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.6.0.tar.gz"
  sha256 "67afa98e0f0f0b32bab59fadd17fc82c08b7a3bc72e530775ba6bed08e683310"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4535772e5ce735896f564bbfec0f3b78e3ca1fd763062e31d3a5ae326143ebaf" => :el_capitan
    sha256 "40353f161da122194193c9a358145fc4b565fbbcf375f87c7aef53474cce788f" => :yosemite
    sha256 "d81a388c284e560b444bdb1639ac99919112b11ea9c6e13ca4f5e9c4d159f696" => :mavericks
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
