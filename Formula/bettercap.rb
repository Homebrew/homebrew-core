class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.24.1.tar.gz"
  sha256 "590cef2b2b24fd9f67c57c8cb19ab8ff08b11d43bfc23b468013ddad907bb8b8"

  bottle do
    cellar :any
    sha256 "14b45b8058c5fc416d60b880d4e9daaae8f12796c989ad2ba852a865ef0bf49f" => :mojave
    sha256 "66429c40f9bdb8ac395923de409e4763ed06d5161ff37a0c8ca448983e157695" => :high_sierra
    sha256 "c3032e65eff8fd355b38e4aa8597bf68e877b68f94f5879e518910c3b5d590b0" => :sierra
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
