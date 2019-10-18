class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.26.tar.gz"
  sha256 "efa9d6a6c63d715c05a8898ff84bde8d9ded022296b14245a545a6161cc6f1f6"

  bottle do
    cellar :any
    sha256 "291d3974c236a92a28355f510b0488d4936013ce1f76dafd657962ebfa9cf85f" => :catalina
    sha256 "11f0d79d8e62f825359be195cc0afff39f65636ae88ec0b2ea3a342a09498918" => :mojave
    sha256 "3f3433851f6558f3f935895cef8ce7842328e63533607878336369b8228a9e8e" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/bettercap/bettercap").install buildpath.children

    cd "src/github.com/bettercap/bettercap" do
      system "make", "build"
      bin.install "bettercap"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    bettercap requires root privileges so you will need to run `sudo bettercap`.
    You should be certain that you trust any software you grant root privileges.
  EOS
  end

  test do
    assert_match "bettercap", shell_output("#{bin}/bettercap -help 2>&1", 2)
  end
end
