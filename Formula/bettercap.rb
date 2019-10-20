class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.26.tar.gz"
  sha256 "efa9d6a6c63d715c05a8898ff84bde8d9ded022296b14245a545a6161cc6f1f6"

  bottle do
    cellar :any
    sha256 "4eae0c301515c74beac150ebfab016733cd48ad80ddeceaa0d77ea9ef6d76fd0" => :catalina
    sha256 "202a73b72ee8bc22945e6e41905126308345d868d17b2330a0ffd20b5d51710b" => :mojave
    sha256 "eee01b5a166fa40860fb3424cb903994ecf295778fea133d28ec04ee2bd1e368" => :high_sierra
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
