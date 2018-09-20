class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v1.0.2.tar.gz"
  sha256 "395408a3dc9c3db2b5c200b8722a13a60898c861633b99e6e250186adffd1370"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "cf2dd183dc2df8dba76b838bae22f8fdf237ab1a2b319d90c319326b2e8ff20b" => :mojave
    sha256 "da853081d620c5dd83cc688049dca2cc1bc9bd4afd9ae46b392bc899e25b6326" => :high_sierra
    sha256 "eca01c6ab16140a7c519e4c9cee43183e6fba1de6c7e86442683991eba179971" => :sierra
    sha256 "d7ba00c58601266044fdaaef8ce42cb9ba33823251e665944d5330873a673118" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec
    dir = buildpath/"src/github.com/getgauge/gauge"
    dir.install buildpath.children
    ln_s buildpath/"src", dir
    cd dir do
      system "go", "run", "build/make.go"
      system "go", "run", "build/make.go", "--install", "--prefix", prefix
    end
  end

  test do
    assert_match version.to_s[0, 5], shell_output("#{bin}/gauge -v")
  end
end
