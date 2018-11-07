class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v1.0.3.tar.gz"
  sha256 "c0092f40940469853ef0810b6ae388b405b60c7a40dc5585af841652da40cee8"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "a326f7e1457f12a543bbd301654062eddeca86487c71c8aadfe1ee735b208733" => :mojave
    sha256 "dccd456a508201413ff8801db01260e9d496c1f3609641de8105a18b10383c2f" => :high_sierra
    sha256 "d5e618dee85aefa4809db7945f2ac8d9f3f46bdb42a63fb4c5311c126c84a136" => :sierra
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
