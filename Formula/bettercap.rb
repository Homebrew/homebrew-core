class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.24.1.tar.gz"
  sha256 "590cef2b2b24fd9f67c57c8cb19ab8ff08b11d43bfc23b468013ddad907bb8b8"

  bottle do
    cellar :any
    sha256 "b802da09471f36181f834be50b05d90456168e574a21e24c4a2824b66f24fe97" => :mojave
    sha256 "ff63af366f56027fb2fbc426d386f54a028c9a287a64c006135ac5b52f38ee86" => :high_sierra
    sha256 "974a6a0bcf3ccf37b6131f1361d4676da7e1e1c061dcbe4c2bc8d2cb2555adff" => :sierra
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
