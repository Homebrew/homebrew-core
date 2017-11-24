class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.9.5.tar.gz"
  sha256 "630bac56d1f855eebefc43b6f9e8a43362aced8c2c0fe7095db9a3b3387fbf26"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "dce11edbf9996c1a7967d7ff4ad58de43d4146a9652b2941af31752f2edb88dd" => :high_sierra
    sha256 "b5461dcf70512fe8dbbaf9760a2785d06fd3e3f150c22cb199599ab7eb273e3f" => :sierra
    sha256 "fa60a25654a2e73caff1c0b0a001331b723d85621ea43518579d9678934ba174" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec
    dir = buildpath/"src/github.com/getgauge/gauge"
    dir.install buildpath.children
    ln_s buildpath/"src", dir
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
