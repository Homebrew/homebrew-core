class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v1.0.4.tar.gz"
  sha256 "fa46ebc523a401f29297ca3ed39e231402fdc75a0d6121d06c15520347e34f08"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e75eca3bb23978e3adc339d2e2959baa8e0f1efa9fc2d43eb31558a40232798" => :mojave
    sha256 "e22b52fd24ef4a8fe5e8e5b31cbd90b8c4bbb72114f5d510f56ede1fb3671a34" => :high_sierra
    sha256 "1ab551891eafd2e14f1253d4a6036fb9802ab40dff7ba0c8d4117d93d3446270" => :sierra
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
