require "language/go"

class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.9.0.tar.gz"
  sha256 "1e0319c618052e488bbd7eec168ad63e4711cf6fd7bbe2343a6acf8c5253dfbd"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "61297c5005d8d2af0b0a0c6e52161a2911f9c646d552a17a82dedd729e9608af" => :sierra
    sha256 "9933d6da1783b8d456af364705bc4fbd7b78161db5c539337e4b3f5b835fd0cd" => :el_capitan
    sha256 "61aaa2767ec4267036db8897bf1bf0521f50e209ffb5d72a069875f815abaedf" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/getgauge/gauge_screenshot" do
    url "https://github.com/getgauge/gauge_screenshot.git",
        :revision => "23dd83ae2eeed5be12edc9aa34bb34246cebe866"
  end

  go_resource "github.com/apoorvam/goterminal" do
    url "https://github.com/apoorvam/goterminal.git",
        :revision => "4d296b6c70d14de84a3ddbddb11a2fba3babd5e6"
  end

  go_resource "github.com/daviddengcn/go-colortext" do
    url "https://github.com/daviddengcn/go-colortext.git",
        :revision => "3b18c8575a432453d41fdafb340099fff5bba2f7"
  end

  go_resource "github.com/dmotylev/goproperties" do
    url "https://github.com/dmotylev/goproperties.git",
        :revision => "7cbffbaada472bc302cbaca51c1d5ed2682eb509"
  end

  go_resource "github.com/fsnotify/fsnotify" do
    url "https://github.com/fsnotify/fsnotify.git",
        :revision => "4da3e2cfbabc9f751898f250b49f2439785783a1"
  end

  go_resource "github.com/getgauge/common" do
    url "https://github.com/getgauge/common.git",
        :revision => "2b2fd2955fd0589d68346b39909bed3f8f538b4c"
  end

  go_resource "github.com/getgauge/mflag" do
    url "https://github.com/getgauge/mflag.git",
        :revision => "d64a28a7abc05602c9e6d9c5a1488ee69f9fcb83"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
        :revision => "8ee79997227bf9b34611aee7946ae64735e6fd93"
  end

  go_resource "github.com/inconshreveable/mousetrap" do
    url "https://github.com/inconshreveable/mousetrap.git",
        :revision => "76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
  end

  go_resource "github.com/jpillora/go-ogle-analytics" do
    url "https://github.com/jpillora/go-ogle-analytics.git",
        :revision => "14b04e0594ef6a9fd943363b135656f0ec8c9d0e"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
  end

  go_resource "github.com/natefinch/lumberjack" do
    url "https://github.com/natefinch/lumberjack.git",
        :revision => "dd45e6a67c53f673bb49ca8a001fd3a63ceb640e"
  end

  go_resource "github.com/op/go-logging" do
    url "https://github.com/op/go-logging.git",
        :revision => "970db520ece77730c7e4724c61121037378659d9"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
        :revision => "5bf94b69c6b68ee1b541973bb8e1144db23a194b"
  end

  go_resource "github.com/sourcegraph/go-langserver/" do
    url "https://github.com/sourcegraph/go-langserver.git",
        :revision => "66ff4f536c4fe4a5c525472820a563939a0ab00f"
  end

  go_resource "github.com/sourcegraph/jsonrpc2" do
    url "https://github.com/sourcegraph/jsonrpc2.git",
        :revision => "b02337b177765febba753be4b7d9c26e3a9fd220"
  end

  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
        :revision => "8c6fa02d2225de0f9bdcb7ca912556f68d172d8c"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
        :revision => "e57e3eeb33f795204c1ca35f56c44f83227c6e66"
  end

  go_resource "golang.org/x/net/" do
    url "https://github.com/golang/net.git",
        :revision => "ab5485076ff3407ad2d02db054635913f017b0ed"
  end

  go_resource "golang.org/x/sys/" do
    url "https://github.com/golang/sys.git",
        :revision => "7a4fde3fda8ef580a89dbae8138c26041be14299"
  end

  go_resource "google.golang.org/grpc" do
    url "https://github.com/grpc/grpc-go.git",
        :revision => "50955793b0183f9de69bd78e2ec251cf20aab121"
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
      system "go", "run", "build/make.go"
      system "go", "run", "build/make.go", "--install", "--prefix", prefix
    end
  end

  test do
    assert_match version.to_s[0, 5], shell_output("#{bin}/gauge -v")
  end
end
