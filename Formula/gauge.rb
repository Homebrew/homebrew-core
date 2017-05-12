require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.8.4.tar.gz"
  sha256 "303f5bb845045c92ca0b8ec28173ce4a380c96bad1c9fced5ea8f77a56b7ea2a"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "c5b11df4afbe6ec9210381e870dd6bd41de358e2e3fe033c8f8e4384b6072a58" => :sierra
    sha256 "dc6b5146e8a7db1f321edb5eb55bb003a48a17023a90b263e516fbdc7e84f046" => :el_capitan
    sha256 "d5406a6996795f0836776f16e0b82e2bc516ce5190e05d3d8851bfeccfdc462f" => :yosemite
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
