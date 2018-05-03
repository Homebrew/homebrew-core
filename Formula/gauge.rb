class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.9.8.tar.gz"
  sha256 "ba63c6c0571751e283f5742bf4b849610e451785c2f639c54a4857210b8941ff"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "1e82dfc7eaed111730eb75b830fdb3888617ecddde9f493b70901133c4ca0ada" => :high_sierra
    sha256 "a5d4aa1090d8266080b3c68daddc6475113dbe1857d7185b6c03a3b28a3f7820" => :sierra
    sha256 "89c8bab4f0fd5f3d8681c672587bff6246c2d063d7f727977a6f265c5b9370e5" => :el_capitan
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
