class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.21.1.tar.gz"
  sha256 "8b38d177024f2e77b32b35682627f5889f0650c69ab6d602472bdc65a16d8b07"

  bottle do
    cellar :any
    sha256 "98165640dc5801948563a211ce3c271cec737539d404a6c8ef0ce2e03cefc332" => :mojave
    sha256 "e21cc18cc1c0bf84d1e3736bd4d8a78e28a5d98134707cee768344b9044ce0e4" => :high_sierra
    sha256 "aef6994094164fc1aaee47eeb54f608dd4949a852fdc8a7bedf751ecaf43735d" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/bettercap/bettercap").install buildpath.children

    cd "src/github.com/bettercap/bettercap" do
      system "dep", "ensure", "-vendor-only"
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
