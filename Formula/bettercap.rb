class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.6.tar.gz"
  sha256 "f91761fbaf16b3fdde3c89fec05f4a72684f8e444af66f712146beac8e88e8f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e5c656df33fa77a5acfe0ca6e8551c64bf6eb5ea6e2ce297f322743e3be6a97" => :high_sierra
    sha256 "01e414ba76787aa4f70e69473a55eb714c66f7ad18c872e7bb621a40b5ef5e32" => :sierra
    sha256 "1c88b6fee5975cbc5588d64d6685476e32e48f829fd54bb33d9975e035263b9b" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

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
