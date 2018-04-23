class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.5.tar.gz"
  sha256 "90f437ce132cc080c573a5bbc568d31859105117db2e1bf77f209c01ef2fa5ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e26b07929e45bd16163a51dcd280875f090d716f272fe4ec6df23960e58a4b0" => :high_sierra
    sha256 "ef93bf4777bb48125700cf2f795340e410f63d72f8ff5701f6523c5ceea6aea1" => :sierra
    sha256 "dbe475c3a08e31da8e600bda55ee3c5128fe5421a55c351cf839d858d4ada921" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/bettercap/bettercap").install buildpath.children

    cd "src/github.com/bettercap/bettercap" do
      system "dep", "ensure"
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
