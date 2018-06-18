class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v1.0.0.tar.gz"
  sha256 "8d77e25d9050a3e8ccd8150f4f744a2bf6e1e43a4ba91fcceaeaaf5a767573c6"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 "3ee80ea49ab77d331b37b1cfd8f42de73a9b40aade02e7a82f518ddcde84e0ab" => :high_sierra
    sha256 "d6db66c0ac643f4fa462758d4361337dfa45b8505c1a5d4a921a059e80a3555d" => :sierra
    sha256 "2833b60e5d602e6288ed4c2ac513346cc0f41ee1f7d6fb91183098306fdb1ce5" => :el_capitan
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
