require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.8.4.tar.gz"
  sha256 "303f5bb845045c92ca0b8ec28173ce4a380c96bad1c9fced5ea8f77a56b7ea2a"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "2429641222286b88d4df4762a0d03a075a2a381bdc52c8366aceea39d7b390f0" => :sierra
    sha256 "19fc9e72f43a62601a13295a3e930b6965b92f28153009eb0e8e980ff577febb" => :el_capitan
    sha256 "af7c4fc397558f0db55c9678c3bd734abb3d6f8b4b4f91c50b969caec8760445" => :yosemite
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
