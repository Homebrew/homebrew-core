class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.6.tar.gz"
  sha256 "f91761fbaf16b3fdde3c89fec05f4a72684f8e444af66f712146beac8e88e8f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "3396790460a1114371a34a3e137584cc34fbd6eb1c9139a67925b1e190ba24d1" => :high_sierra
    sha256 "01d03781a4ee2d0422aa6892d924d1a1f55ea0bae1fe863212fd87aeaafc7dac" => :sierra
    sha256 "eb831c4db58c28006068a91c78dc948b41a3dea0d8a251a03b209bdb2cc93b34" => :el_capitan
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
