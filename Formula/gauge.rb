class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v1.0.0.tar.gz"
  sha256 "8d77e25d9050a3e8ccd8150f4f744a2bf6e1e43a4ba91fcceaeaaf5a767573c6"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "c9ab05af16d66e08c7a1847eca63821f198eff42a863c9fc862347988fd74956" => :high_sierra
    sha256 "ec90f73026d039563c630e0e221e7e95210c55c9702ab413cd041cbc8e2833e4" => :sierra
    sha256 "adc703beb018fbb854d9e615a5fe5f81edf33af7a2c66db8d18240b99a493d87" => :el_capitan
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
