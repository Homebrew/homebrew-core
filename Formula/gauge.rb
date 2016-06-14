require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "http://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.5.0.tar.gz"
  sha256 "be7ed28de6f478ca08c361618e22226d73a84a5b679403ebdd21a4d8bfbb4dcd"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6793d3aa9fee7dc8481be6dc6c9e157b852e702b50cd019dde95aa9ad607622" => :el_capitan
    sha256 "6658d008e493c622f93890a31f9e8260b0a58c244703927f6038b37bc0cf2f35" => :yosemite
    sha256 "87169632ce339e1be1ec3e1e43e7f7bf42f4605c2f7eb1accfa883194c013e5d" => :mavericks
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
