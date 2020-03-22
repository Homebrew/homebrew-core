class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v1.0.8.tar.gz"
  sha256 "9757b568e53730caa3699f0d9ccc87af0b30091b3655674c61aaf6de8164837c"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "51f82b71c70bca6bbbb26c26d4e5757b294ebd8aa7dd67c01563e059681c73fb" => :catalina
    sha256 "d1fbb4d76fb5a5eacf77cac57cae90954bebd1b4ae83ba05ee7134c9c27d7061" => :mojave
    sha256 "42f5f8f1b221e7fa4c83b4b04cd9c058d338d40f2bae77a5eee356a5772f3a85" => :high_sierra
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
