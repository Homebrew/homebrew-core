class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v0.9.6.tar.gz"
  sha256 "56d1df65e53d716ef7b770dd207cd41ae34f4f97cddca4a7db7018d1021a5843"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "accd9dba0e8b71456e61ff25de54ed7136fba7b382f5df036d6801a36aea1eb7" => :high_sierra
    sha256 "f4917ccf7d09973a01f604f5ebc8eb908cd32d7da9f522e959287b38cd877e3f" => :sierra
    sha256 "74f2c68fe1083d759631a8c7ff812938c1fbeba908bf8860b8967d6a5d0dc4d4" => :el_capitan
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
