class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.9.3.tar.gz"
  sha256 "3bb9e13da409b40e7982199418e7449560ee6c14d7e99581dd30c94c4c6f88de"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "d6c99ce55dfd3c24a57c67a529254ebb9fa0af7a5afeed945a54600504cb7fb1" => :high_sierra
    sha256 "03a3e9061c662ac63ebe1b14f1e3af9de53815ddac8ccd2d1101c0e08294a046" => :sierra
    sha256 "637f411f6eb43e161b45e4baec7c51f2cf6c1b3b6cc30fd094c7ce15230a6552" => :el_capitan
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
