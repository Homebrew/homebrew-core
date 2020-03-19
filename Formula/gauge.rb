class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v1.0.8.tar.gz"
  sha256 "9757b568e53730caa3699f0d9ccc87af0b30091b3655674c61aaf6de8164837c"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c197ce095e57f0d5c17d38e34380e594aef73b541817639d7739f754594bbbc" => :catalina
    sha256 "209fd327d3b01a335e80b7d4b6f59ffe9ef230df2f94303291d2c130180f43d8" => :mojave
    sha256 "742e9e4c57a2e0c087101e91801a0729dc4b1654167d9a80cd6aa803085b6c43" => :high_sierra
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
