class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.9.8.tar.gz"
  sha256 "ba63c6c0571751e283f5742bf4b849610e451785c2f639c54a4857210b8941ff"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "cd1c23c738966a4fca71d73ed1c5515fcd87e6f12ea8cfa49503a8a747688886" => :high_sierra
    sha256 "a78e695a386a5a76f5334e0d7e34102ab93783926ac81eff6b5c756e96d19d95" => :sierra
    sha256 "66fc57093287cd847fc326df9c5b839f97f1c997ba2f36dfd73ba3850be0b407" => :el_capitan
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
